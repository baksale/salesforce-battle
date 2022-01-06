#!/bin/bash

echo "Creating scratch org for development..."
echo "sfdx force:org:create -f config/project-scratch-def.json -s -a battle"
# sfdx force:org:create -f config/project-scratch-def.json -s -a battle

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not create scratch org";
    exit $rc;
fi
echo "Scratch Org created successfully"


echo "Clonning fflib Apex Mocks repositroy into tmp folder..."
echo "git clone git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git tmp && cd tmp"
git clone git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git tmp && cd tmp

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not clone fflib Apex Mocks repository";
    exit $rc;
fi
echo "Clonned fflib Apex Mocks repository"


echo "Pushing fflib Apex Mocks repositroy into scratch org..."
echo "sfdx force:source:push -f -u battle && cd .."
sfdx force:source:push -f -u battle && cd ..

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not push fflib Apex Mocks source into scratch org";
    exit $rc;
fi
echo "Pushed fflib Apex Mocks source code into scratch org"


echo "Pushing Salesforce Battle repositroy into scratch org..."
echo "sfdx force:source:push -f -u battle"
sfdx force:source:push -f -u battle

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not push Salesforce Battle source into scratch org";
    exit $rc;
fi
echo "Scratch Org is ready for new Tank construction"
