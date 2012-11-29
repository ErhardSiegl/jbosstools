HOST=`hostname`
echo Create keypair for $HOST
keytool -genkeypair -alias jboss -keyalg RSA -keystore server.keystore -storepass passwort -keypass passwort --dname "CN=$HOST,OU=Engineering,O=Objectbay,L=Traun,C=AT"

echo Create Certificate request
keytool -certreq -keyalg RSA -alias jboss -keystore server.keystore -file certreq.csr -storepass passwort

echo Create self signed Certificate
keytool -export -alias jboss -keystore server.keystore -file server.crt -storepass passwort

# echo Import self signed Certificate
# keytool -import -keystore server.keystore -alias jboss -file server.crt -storepass passwort

# Export Private Key and convert it to X509
# keytool -importkeystore -srckeystore server.keystore -destkeystore server.pfx -deststoretype PKCS12
# openssl pkcs12 -in server.pfx -out server.pem -nodes
#Infos auslesen
# openssl x509 -text -in server.pem 

KEYSTORE_DIR=$JBOSS_HOME/standalone/configuration/keystores/

echo use: $KEYSTORE_DIR
mkdir $KEYSTORE_DIR
cp server.keystore $KEYSTORE_DIR

