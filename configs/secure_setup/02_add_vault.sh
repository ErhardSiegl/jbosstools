
KEYSTORE_DIR=$JBOSS_HOME/standalone/configuration/keystores/

echo use: $KEYSTORE_DIR
mkdir $KEYSTORE_DIR
cp ENC.dat  Shared.dat vault.keystore $KEYSTORE_DIR

# Keystore generiert mit 

# keytool -genkey -alias vault -keyalg RSA -keysize 1024 -keystore vault.keystore <<EOF
# passwort
# passwort
# Erhard Siegl
# TCS
# Objectbay
# Traun
# OOe
# AT
# yes
# 
# EOF

# $JBOSS_HOME/bin/vault.sh 


# Keystore enthält Wert "sa" für
# VAULT::defaultDS::password::YzEwYTQ5MjktODE5Ni00MzJmLTgxYTgtOTM1MjI4YmI4ZjdiTElORV9CUkVBS3ZhdWx0
