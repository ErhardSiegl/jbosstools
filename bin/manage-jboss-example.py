#!/usr/bin/python

import simplejson as json
import urllib2
import pprint
pp = pprint.PrettyPrinter(indent=2, width=10)

url = "http://localhost:9990/management"

address = [    
       {'socket-binding-group' : 'standard-sockets'},
       {'socket-binding' : 'http'}
     ]

method = {
        'address' : address,
		'operation' : 'read-resource',
     }

def callJBoss( url, method):
	req = urllib2.Request(url, json.dumps(method), {'Content-Type': 'application/json'})
	return urllib2.urlopen(req)

def setupAuthentication(url, username, password):
	password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
	password_mgr.add_password('ManagementRealm', url, username, password)
	handler = urllib2.HTTPDigestAuthHandler(password_mgr)
	opener = urllib2.build_opener(handler)
	urllib2.install_opener(opener)

setupAuthentication(url, 'admin', 'jboss')

res = callJBoss(url, method)
erg = json.loads(res.read())
pp.pprint(erg)

