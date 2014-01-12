RoleFile=$JBOSS_HOME/standalone/configuration/application-roles.properties

$JBOSS_HOME/bin/add-user.sh admin jboss@123 ManagementRealm
$JBOSS_HOME/bin/add-user.sh -a guest guest@123 ApplicationRealm

sed -i 's/^.*guest=.*/guest=guest/' $RoleFile
#sed -i 's/^.*guest=/#&/' $RoleFile
#echo  >> $RoleFile
#echo guest=guest >> $RoleFile
