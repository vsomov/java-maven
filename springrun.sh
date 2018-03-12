#!/bin/sh

#######################################################################
# Builds Springboot app with Maven inside Docker container and runs it
#######################################################################

set -e

BUILDDIR=/opt
MVN_ARGS=""
JAVA_OPTS=""
BUILD_TAG="inklander/java-maven:springboot"
REPO="https://github.com/vsomov/java-maven.git"


java -jar /opt/springboot-sample-app/target/app.jar &&

#git clone $REPO
#cd java-maven
#docker build -t "$BUILD_TAG" .
#docker images | grep springboot | awk {'print $3'}
#docker tag 57774804eca7 inklander/java-maven:springboot
#docker login --username=inklander
#docker push inklander/java-maven
#docker exec -it 001 java $JAVA_OPTS -jar /opt/springboot-sample-app/target/app.jar
