#
# Java & Maven Dockerfile
#
# https://github.com/vsomov/java-maven.git
#

# pull base image.
FROM openshift/base-centos7

EXPOSE 8080

ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.3.9
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 66
ENV JAVA_VERSION_BUILD 17
ENV JAVA_PACKAGE server-jre
#ENV JAVA_HOME /opt/java
ENV JAVA_HOME /usr/lib/jvm/java
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin
ENV MAVEN_HOME /opt/maven

LABEL name="Openshift CentOS Base Image" \
    vendor="CentOS" \
    license="GPLv2" \
	io.k8s.display-name="Maven 3 Spring app" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,java,java8,maven,maven3,springboot"

# create working directory
RUN mkdir -p /opt
WORKDIR /opt

# update packages and install Java
RUN  \
  yum -y update && \
  yum -y install vim wget curl git && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all
  
# Oracle...
#  curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
#  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar -xzf - -C /opt && \
#  ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/java && \

# Maven
RUN \
  curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /opt && \
  ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven && \
  ln -s /opt/maven/bin/mvn /usr/bin/mvn

# attach volumes
VOLUME /volume/git

# Maven build

RUN \
  git clone https://github.com/vsomov/java-maven.git && \
  git clone https://github.com/vsomov/springboot-sample-app.git && \
  cd springboot-sample-app/ && \
  mvn clean install > /opt/mvnlog.txt

#  mvn spring-boot:run && \

# Add additional files
COPY ./src/ /opt/src/
#ADD java-maven.sh /opt/java-maven/java-maven.sh
#cd java-maven && \
#CMD ["bash","/root/maven/java-maven.sh"]

RUN chown -R 1001:0 /opt/
USER 1001

# Set the default CMD to print the usage of the language image
CMD /opt/src/usage

# run terminal
CMD ["/bin/bash"]