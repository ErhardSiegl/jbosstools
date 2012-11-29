
KEYSTORE_DIR=$JBOSS_HOME/standalone/configuration/keystores/

echo use: $KEYSTORE_DIR
mkdir $KEYSTORE_DIR
cp ENC.dat  Shared.dat vault.keystore $KEYSTORE_DIR

cat<<'EOF'>tmp_vault

    <vault>
        <vault-option name="KEYSTORE_URL" value="${jboss.server.config.dir}/keystores/vault.keystore"/>
        <vault-option name="KEYSTORE_PASSWORD" value="MASK-1CjcBL7EGFMlqb/ECsmaHH"/>
        <vault-option name="KEYSTORE_ALIAS" value="vault"/>
        <vault-option name="SALT" value="12345678"/>
        <vault-option name="ITERATION_COUNT" value="33"/>
        <vault-option name="ENC_FILE_DIR" value="${jboss.server.config.dir}/keystores/"/>
    </vault>

EOF

ed $JBOSS_HOME/standalone/configuration/standalone.xml <<EOF
/management
-
.r tmp_vault
wq
EOF

rm tmp_vault

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
