#!/bin/bash

scratchOrg="battle"
echo "Creating scratch org for development..."
echo "sfdx force:org:create -f config/project-scratch-def.json -d 30 -s -a $scratchOrg"
sfdx force:org:create -f config/project-scratch-def.json -d 30 -s -a $scratchOrg

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
echo "sfdx force:source:push -f -u $scratchOrg && cd .. && rm -rf tmp"
sfdx force:source:push -f -u $scratchOrg && cd ..&& rm -rf tmp

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not push fflib Apex Mocks source into scratch org";
    exit $rc;
fi
echo "Pushed fflib Apex Mocks source code into scratch org"

echo ""
echo "Pushing Salesforce Battle repositroy into scratch org..."
echo "sfdx force:source:push -f -u $scratchOrg"
sfdx force:source:push -f -u $scratchOrg

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not push Salesforce Battle source into scratch org";
    exit $rc;
fi

sfdx force:user:permset:assign -n BattleManagement

echo ""
echo "Uploading static data and battles history..."
echo "./scripts/import-data.sh"
./scripts/import-data.sh

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not upload static data and battles history into scratch org";
    exit $rc;
fi
echo ""


echo ""
echo "Scheduling regular battles..."
echo "sfdx force:apex:execute -f scripts/scheduler.apex"
sfdx force:apex:execute -f scripts/scheduler.apex

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not upload static data and battles history into scratch org";
    exit $rc;
fi
echo ""
echo "Scratch Org is ready for new Tank construction"
