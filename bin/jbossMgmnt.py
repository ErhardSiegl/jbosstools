#!/usr/bin/python

import simplejson as json
import urllib2
import pprint

#print "Start"

url = "http://localhost:9990/management"
username = 'admin'
password = 'jboss'

def callJBoss( op):
	req = urllib2.Request(url, json.dumps(op), {'Content-Type': 'application/json'})
	return urllib2.urlopen(req)

def setupAuthentication():

	password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
	password_mgr.add_password('ManagementRealm', url, username, password)
	
	handler = urllib2.HTTPDigestAuthHandler(password_mgr)

	# create "opener" (OpenerDirector instance)
	opener = urllib2.build_opener(handler)
	
	# Install the opener.
	# Now all calls to urllib2.urlopen use our opener.
	urllib2.install_opener(opener)



ad0 = [
           {'socket-binding-group' : 'standard-sockets'},
           {'socket-binding' : 'http'}
           ]
 
        
op0 = {'operation' : 'write-attribute',
             'address' : ad0,
             'name' : 'port',
             'value' : '8081'
             }

ad1 = [    
       {'socket-binding-group' : 'standard-sockets'},
       {'socket-binding' : 'http'}
       ]

ad2 = [ ]

op1 = {'operation' : 'read-operation-names',
             'address' : ad1,
             }

op2 = {'operation' : 'read-operation-description',
             'address' : ad2,
             'name' : 'read-resource-description'
             }

op3 = {'operation' : 'read-resource',
             'address' : ad1,
             }

op4 = {'operation' : 'read-operation-description',
             'address' : ad1,
             'name' : 'write-attribute'
             }

op5 = {'operation' : 'read-resource',
             'address' : ad2,
             }

op6 = {'operation' : 'read-resource-description',
             'address' : ad1,
             }

setupAuthentication()

res = callJBoss(op3)
# print res.read()

pp = pprint.PrettyPrinter(indent=2, width=10)

erg = json.loads(res.read())
pp.pprint(erg)
       
#print "End"

