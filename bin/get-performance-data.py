#!/usr/bin/python

import simplejson as json
import urllib2
import pprint
import argparse
import logging as log
from datetime import datetime

user = "admin"
password = "jboss"
url = "http://localhost:9990/management"
loglevel = "DEBUG"

parser = argparse.ArgumentParser(description="Get performance data from WildFly server")
parser.add_argument("-u", "--user",     default=user, help="Admin user. Default: " + user)
parser.add_argument("-p", "--password", default=password, help="Admin password. Default: " + password)
parser.add_argument("-l", "--loglevel", default=loglevel, help="Loglevel (DEBUG, INFO, ERROR. Default: " + loglevel)
parser.add_argument("-r", "--url", default=url, help="Management-URL. Default: " + url)
args = parser.parse_args()

user     = args.user    
password = args.password    
url      = args.url    
loglevel = args.loglevel

log.basicConfig(level=getattr(log, loglevel.upper()))

log.info('Start')

pp = pprint.PrettyPrinter(indent=2, width=10)

class Measurable(object):
    """Class that provides metrics"""

    def __init__(self, info, name):
        self.info = info
        self.name = name
        self.children = []
        self.time = 0

        
    def updateMetrics(self, metrics):
        self.updateThisMetrics(metrics)
        for child in self.children:
            child.updateMetrics(metrics)

    def updateThisMetrics(self, metrics):
        return

    def appendChild(self, child):
        self.children.append(child)

    def appendChildren(self, children):
        for child in children:
            self.children.append(child)

    def setTime(self, time):
        self.time = time
        
    def setSimpleMetric(self, metrics, key):
        metrics[self.name + '.' + key] = self.info[key]


class WildFlyManagement(Measurable):
    """Wildfly Management Server"""
    url = None

    def __init__(self, url, user, password):
        super(WildFlyManagement, self ).__init__(None, 'WildFly')
        self.setupAuthentication(url, user, password)
        self.url = url
        self.appendChildren(self.getDeployments())
        
    def setupAuthentication(self, url, username, password):
        password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
        password_mgr.add_password('ManagementRealm', url, username, password)
        handler = urllib2.HTTPDigestAuthHandler(password_mgr)
        opener = urllib2.build_opener(handler)
        urllib2.install_opener(opener)
    
    def measure(self, time):
        self.children = []
        self.appendChildren(self.getDeployments())
        self.setTime(time)
        return self
        
    def fail(self):
        exit(1)
    
    def execute(self, method):
        req = urllib2.Request(self.url, json.dumps(method), {'Content-Type': 'application/json'})
        try: 
            erg = json.loads(
                        urllib2.urlopen(req).read()
                    )
            if erg["outcome"] == 'success':
                return erg["result"] 
            log.error('Call failed: ' + erg["result"])
        except urllib2.HTTPError, e:
            log.error('HTTPError = ' + str(e.code) + ' ' + e.reason)
        except urllib2.URLError, e:
            log.error('URLError = ' + str(e.reason))
        except Exception:
            import traceback
            log.error('generic exception: ' + traceback.format_exc())
        self.fail()

    def readDeploymentsMethod(self):
        address = [    
         ]
        method = {
            'address' : address,
            'operation' : 'read-children-names',
            'child-type' : 'deployment',
         }
        return method

    def getDeployments(self):
        deployments = []
        for name in self.execute(self.readDeploymentsMethod()):
            deployments.append(Deployment(self, name))
        return deployments

class Deployment(Measurable):
    """Wildfly Deployment"""

    def __init__(self, server, name):
        super(Deployment,self).__init__(server.execute(self.readAllMethod(name)), name)
        self.appendChild(self.getWebSubsystem())
        self.appendChild(self.getEjb3Subsystem())
        
    def readAllMethod(self, name):
        address = [    
           {'deployment' : name},
         ]
        method = {
            'address' : address,
            'operation' : 'read-resource',
            'include-runtime' : 'true',
            'recursive' : 'true',
         }
        return method
    
    def getWebSubsystem(self):
        return WebSubsystem(self.info['subsystem']['web'], self.name + '.Web')

    def getEjb3Subsystem(self):
        return Ejb3Subsystem(self.info['subsystem']['ejb3'], self.name + '.Ejb3')

        
class WebSubsystem(Measurable):
    """Wildfly WebSubsystem within a deployment"""

    def __init__(self, info, name):
        super(WebSubsystem, self).__init__(info, name)
        self.appendChildren(self.getServlets())

    def getServlets(self):
        servlets = []
        for servletName in self.info['servlet'].keys():
            servlets.append(Servlet(self.info['servlet'][servletName],'Servlet.'+servletName))
        return servlets

    def updateThisMetrics(self, metrics):
        log.debug('WebSubsystem: ' + str(self.info))
        self.setSimpleMetric(metrics, 'active-sessions')
    
    
class Ejb3Subsystem(Measurable):
    """Wildfly Ejb3-Subsystem within a deployment"""

    def __init__(self, info, name):
        super(Ejb3Subsystem, self).__init__(info, name)
        self.appendChildren(self.getStatelessSessionBeans())

    def getStatelessSessionBeans(self):
        beans = []
        log.debug('Ejb3Subsystem: ' + str(self.info))
        for name in self.info['stateless-session-bean'].keys():
            beans.append(Ejb(self.info['stateless-session-bean'][name],'SLSB.'+name))
        return beans
    
class Ejb(Measurable):
    """Wildfly Ejb at runtime"""

    def __init__(self, info, name):
        super(Ejb, self).__init__(info, name)
        self.appendChildren(self.getMethods())
        
    def updateThisMetrics(self, metrics):
        log.debug('Ejb: ' + str(self.info))
        self.setSimpleMetric(metrics, 'pool-current-size')
    
    def getMethods(self):
        beans = []
        for name in self.info['methods'].keys():
            beans.append(Method(self.info['methods'][name], self.name + '.'+name))
        return beans

class Method(Measurable):
    """Wildfly Ejb method at runtime"""

    def __init__(self, info, name):
        super(Method, self).__init__(info, name)
        
    def updateThisMetrics(self, metrics):
        self.setSimpleMetric(metrics, 'invocations')
        self.setSimpleMetric(metrics, 'execution-time')

class Servlet(Measurable):
    """Servlet Runtime Component"""

    def __init__(self, info, name):
        super(Servlet,self).__init__(info, name)

    def updateThisMetrics(self, metrics):
        log.debug('Servlet Info: ' + str(self.info))
        self.setSimpleMetric(metrics,'processingTime')
        self.setSimpleMetric(metrics,'requestCount')
        

server = WildFlyManagement(url, user, password)


now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
metrics = {}
server.updateMetrics(metrics)
log.debug('Komponent Metrics: ' + pp.pformat(metrics))
server.measure(10).updateMetrics(metrics)    
log.debug('Komponent Metrics: ' + pp.pformat(metrics))

log.info('OK')


