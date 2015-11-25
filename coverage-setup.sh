#!/bin/sh
configFile="./coverage.properties"

# read config
. $configFile

echo "Downloading JaCoCo."
wget -q -O jacoco.zip $jacocoURL
mkdir -p lib
rm -f lib/jacocoant.jar
unzip -q jacoco.zip lib/jacocoagent.jar
unzip -q jacoco.zip lib/jacocoant.jar
rm -f jacoco.zip
mv lib/jacocoagent.jar /tmp
echo "JaCoCo agent installed:"
ls -al /tmp/jacocoagent.jar
echo ""

echo "Downloading Ant."
wget -q ${antURL}
tar xfvz apache-ant-${antVersion}-bin.tar.gz >/dev/null
rm -rf /tmp/apache-ant-${antVersion}
mv apache-ant-${antVersion} /tmp
rm apache-ant-${antVersion}-bin.tar.gz
echo "Ant installed in ${antPath}."
echo ""

echo "Looking for vert.x config files in ${configFilesPath}:"
for configFile in `grep ${javaOptsConfigKey} ${configFilesPath}/* | cut -d ':' -f -1`;
do
  echo -n "- found $configFile: "
  checkForAgent=`grep ${javaOptsConfigKey} $configFile | grep '\-javaagent:/tmp/jacocoagent.jar'`
  if [ "$checkForAgent" == "" ]
  then
    echo "replacing ${javaOptsConfigKey}"
    cat $configFile | sed -e "s@${javaOptsConfigKey}=\"*\"@${javaOptsConfigKey}=\"-javaagent:/tmp/jacocoagent.jar=destfile=/tmp/jacoco.exec,append=true @g" > $tmpConfigFile
    mv $tmpConfigFile $configFile
  else
    echo "not replacing ${javaOptsConfigKey}, JaCoCo agent already added."
  fi
done

echo "Stopping app (might take a minute)."
# Hack: stop app multiple times to make sure that hanging processes are killed.
for i in `seq 0 5`
do
  ${appStopCommand} > /dev/null 2>&1
done
echo "App stopped."
echo "Removing previous /tmp/jacoco.exec file (in case it exists)."
rm -f /tmp/jacoco.exec
echo ""
echo "Starting App."
${appStartCommand}
echo "App started."
echo ""
echo -n "Waiting until app is healthy: "
while true
do
  check=`curl -i ${appHealthCheckURL} 2>/dev/null | grep HTTP`
  if [[ "$check" == *"200 OK"* ]]
  then
    # healthy; break loop.
    echo " \o/"
    break
  else
    # unhealthy; log progress and continue loop after a short break.
    echo -n "."
    sleep 2s
  fi
done
echo "App is healthy. Happy testing!"
