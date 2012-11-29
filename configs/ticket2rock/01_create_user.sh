RoleFile=$JBOSS_HOME/standalone/configuration/application-roles.properties

$JBOSS_HOME/bin/add-user.sh admin jboss ManagementRealm
$JBOSS_HOME/bin/add-user.sh -a guest guest1 ApplicationRealm

sed -i 's/^.*guest=.*/guest=guest/' $RoleFile
#sed -i 's/^.*guest=/#&/' $RoleFile
#echo  >> $RoleFile
#echo guest=guest >> $RoleFile
