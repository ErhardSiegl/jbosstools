Simple default slave host-controller
rc-example:

    JBOSS_HOME=$HOME/jboss/slave1
    export JBossPackage=$HOME/Downloads/jboss-eap-6.2.0.zip
    JBOSS_OPTS="-b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.domain.master.address=localhost"
    JBOSS_PORT_OFFSET=500
    DOMAIN_MODE=true
