dnl ----------------------------------------
dnl Default Konfiguration fuer die Installation
dnl ----------------------------------------
dnl Wird mit der Applikation ausgeliefert. Die Einträge koennen oder muessen 
dnl durch umgebunsspezifische Environment-Dateien ueberschrieben werden.
dnl
dnl Achtung: Auf die Anfuehrungszeichen achten, sonst koennen unerwartete Effekte entstehen!
dnl          Am Ende einer Zeile immer mit einem Kommentar "dnl" abschliessen.
dnl
dnl Wo liegt das JBoss-Paket?
define(`CONF_JBossPackage', $HOME/Downloads/jboss-eap-6.0.1.zip)dnl
dnl 
dnl JBoss Admin
define(`CONF_JBOSS_ADMIN_PASSWORD', jboss)dnl
dnl
dnl
define(`CONF_DB_USER', myuser )dnl
define(`CONF_DB_PASSWORD', default_db_password )dnl
