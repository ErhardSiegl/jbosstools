# include(config.m4)dnl
# $JBOSS_HOME/bin/add-user.sh admin jboss ManagementRealm --silent=true 

USERS_FILE=$JBOSS_HOME/standalone/configuration/mgmt-users.properties
DOMAIN_USERS_FILE=$JBOSS_HOME/domain/configuration/mgmt-users.properties

USER="admin"
PWD="jboss"

# changequote(<!,!>)
echo $USER=$( echo -n $USER:ManagementRealm:$PWD | openssl dgst -md5 -hex | cut -d" " -f2 ) > $USERS_FILE
# changequote()

cp $USERS_FILE $DOMAIN_USERS_FILE
