Simple domain-controller setup without servers. See also "slave-setup"
No users for remote slaves are configured. Works when the slave runs under the same host and user als the master.

rc-example:

    JBOSS_HOME=$HOME/eap62-domain
    export JBossPackage=$HOME/Downloads/jboss-eap-6.2.0.zip
    JBOSS_OPTS="-b 0.0.0.0 -bmanagement 0.0.0.0"
    DOMAIN_MODE=true
