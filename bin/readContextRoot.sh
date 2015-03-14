#!/bin/sh

curl -s --digest -u admin:admin@123 --header "Content-Type: application/json" http://localhost:9990/management -d '{"address":["deployment","demo7.war","subsystem","web"], "operation":"read-attribute", "name":"context-root", "json.pretty":1}' | grep result | cut -d'"' -f4
# oder
curl  --digest -u admin:jboss 'http://localhost:9990/management/deployment/demo7.war/subsystem/web?operation=attribute&name=context-root' 
