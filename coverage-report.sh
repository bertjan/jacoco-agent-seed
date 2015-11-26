#!/bin/sh
configFile="./coverage.properties"

# read config
. $configFile

if [ ! -f ${jacocoDataFile} ]; then  echo "JaCoCo data file (${jacocoDataFile}) not found. Something is wrong."
  exit 1
fi

echo "Stopping app (might take a minute)."
# Hack: stop app multiple times to make sure that hanging processes are killed.
for i in `seq 0 5`
do
  ${appStopCommand} > /dev/null 2>&1
done
echo "App stopped."

for package in "${packagesToAnalyze[@]}"
do
# translate package to project name (cut off prefix, replace remaining slashes).
project=`echo $package | sed "s@${packagePrefix}@@g" | sed 's@/@-@g'`
echo ""
echo "${project}"
echo "------------"
echo "Creating coverage report for ${project}."
cat << EOF > build-${project}.xml
<project name="${project}" xmlns:jacoco="antlib:org.jacoco.ant">
<taskdef uri="antlib:org.jacoco.ant" resource="org/jacoco/ant/antlib.xml">
    <classpath path="lib/jacocoant.jar"/>
</taskdef>

<jacoco:report>
    <executiondata>
        <file file="${jacocoDataFile}"/>
    </executiondata>
    <structure name="${project}">
        <classfiles>
            <fileset dir="${appClassesDir}">
                <include name="**${package}/**/*"/>
            </fileset>
        </classfiles>
    </structure>
    <html destdir="report-${project}/"/>
</jacoco:report>
</project>
EOF
rm -rf report-${project}
$antPath -f build-${project}.xml

# zip it.
zip -rq report-${project}.zip report-${project}/
echo "Coverage report: \"report-${project}.zip\"."
done


