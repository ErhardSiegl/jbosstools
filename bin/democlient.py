#!/usr/bin/python

# Client to test Cluster-Configurations with demo7 server-application

import os.path
import urllib2
import sys
import re
import time
from datetime import datetime
import logging

logging.basicConfig(format='%(levelname)s:%(asctime)s %(message)s', level=logging.WARNING)
#logging.getLogger("cookielib").setLevel(logging.DEBUG)
logging.basicConfig()
logger = logging.getLogger("democlient")
logger.setLevel(logging.INFO)

logger.info('Start')

COOKIEFILE = 'cookies.lwp'
# the path and filename to save your cookies in

cj = None
ClientCookie = None
cookielib = None

# Let's see if cookielib is available
try:
    import cookielib
except ImportError:
    print "No cookie-library available, install cookielib"
    exit(-1)
else:
    # importing cookielib worked
    urlopen = urllib2.urlopen
    Request = urllib2.Request
    cj = cookielib.LWPCookieJar()
 
if os.path.isfile(COOKIEFILE):
    # if we have a cookie file already saved
    # then load the cookies into the Cookie Jar
    cj.load(COOKIEFILE, True)

# Now we need to get our Cookie Jar
# installed in the opener;
# for fetching URLs
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
urllib2.install_opener(opener)

if (len(sys.argv) > 1 ):
    url = sys.argv[1]
else:
    url = 'http://devjava:8180/demo/'
    print "Using url %s" % url
    
# an example url that sets a cookie,
# try different urls here and see the cookie collection you can make !

txdata = None
# if we were making a POST type request,
# we could encode a dictionary of values here,
# using urllib.urlencode(somedict)

txheaders =  {'User-agent' : 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'}
# fake a user agent, some websites (like google) don't like automated exploration

def readDemo(req):
    count = 0
    node = "unknown"
    try:
        handle = urlopen(req)
        res = handle.read()
    except IOError, e:
        if hasattr(e, 'code'):
            print 'Failed to open "%s". Error code - %s.' % (url,e.code)
        elif hasattr(e, 'reason'):
            print 'Failed to open "%s".' % url
            print "The error object has the following 'reason' attribute :"
            print e.reason
            print "This usually means the server doesn't exist,"
            print "is down, or we don't have an internet connection."
        return int(count),node
    matchObj = re.match(r'.*Existing session: Value is\s*(\d*)', res, re.S)
    if matchObj:
        count = matchObj.group(1)
        matchObj = re.match(r'.*Session ID: [^\.]*.(\w+)', res, re.S)
        if matchObj:
            node = matchObj.group(1)
    return int(count),node

start = True
last = -1
fail = 0
nodeSave = "unknown"
while True:
    req = Request(url, txdata, txheaders)
    startTime = datetime.now()
    count,node = readDemo(req);
    endTime = datetime.now()
    sec = (endTime - startTime).seconds
    duration = ""
    if sec > 1:
        duration = "took " + str(sec) + " seconds"
    if count <> (last + 1):
        print "Broken between %d and %d for %d seconds." % (last, count, fail)
        fail = fail + 1
    else:
        if node <> nodeSave:
            print "Switch to node", node
            nodeSave = node
        print count,node, duration
        fail = 0
        
    if start == True:
        start = False
    last = count
    try:
        time.sleep(1)
    except KeyboardInterrupt:
        # cj.save(COOKIEFILE, True)
        sys.exit(0);

