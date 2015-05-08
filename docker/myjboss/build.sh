cd `dirname $0`
cp ../../bin/jboss7 .
cp $HOME/Downloads/jboss-eap-6.3.0.zip .

cp -r ../../configs/basic_setup .
touch basic_setup/10_do.interactive

docker build -t erhardsiegl/myjboss:v2 .
