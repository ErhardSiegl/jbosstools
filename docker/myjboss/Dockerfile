FROM fedora:21
MAINTAINER Erhard Siegl <erhard.siegl@gepardec.com>
RUN yum -y install java-1.8.0-openjdk.x86_64
RUN yum -y install unzip.x86_64
ADD jboss7 /usr/local/bin/myjboss
RUN mkdir /usr/local/Downloads
ADD jboss-eap-6.3.0.zip /usr/local/Downloads/jboss-eap-6.3.0.zip
ADD myjbossrc /root/.myjbossrc

ADD basic_setup /usr/local/basic_setup
