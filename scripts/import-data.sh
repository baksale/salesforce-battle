#!/bin/bash

echo "Importing Leagues definitions..."
echo 'sfdx force:data:bulk:upsert -s Account -f data/leagues.csv -i League__c -w 2'
sfdx force:data:bulk:upsert -s Account -f data/leagues.csv -i League__c -w 2

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not import Leagues definitions into Accounts";
    exit $rc;
fi
echo "Imported Leagues successfully"

echo "Importing Tank Model Authors..."
echo 'sfdx force:data:bulk:upsert -s Contact -f data/authors.csv -i GithubUserName__c -w 2'
sfdx force:data:bulk:upsert -s Contact -f data/authors.csv -i GithubUserName__c -w 2

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not import Authors into Contacts";
    exit $rc;
fi
echo "Imported Tank Model Authors successfully"

echo "Importing Tank Models..."
echo 'sfdx force:data:bulk:upsert -s Product2 -f data/tankModels.csv -i TankModel__c -w 2'
sfdx force:data:bulk:upsert -s Product2 -f data/tankModels.csv -i TankModel__c -w 2

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not import Tank Models into Products";
    exit $rc;
fi
echo "Imported Tank Model successfully"

echo ""
echo "Importing Battles..."
echo 'sfdx force:data:bulk:upsert -s Opportunity -f data/battles.csv -i BattleId__c -w 2'
sfdx force:data:bulk:upsert -s Opportunity -f data/battles.csv -i BattleId__c -w 2

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not import Battles into Opportunities";
    exit $rc;
fi

echo ""
echo "Enrich Battles with Price Books"
echo "sfdx force:apex:execute -f scripts/opportunityPriceBook.apex"
sfdx force:apex:execute -f scripts/opportunityPriceBook.apex

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not update Battles with Price Books";
    exit $rc;
fi
echo "Imported Battles successfully"

echo ""
echo "Importing Battle Players..."
echo 'sfdx force:data:bulk:upsert -s OpportunityLineItem -f data/players.csv -i PlayerId__c -w 2'
sfdx force:data:bulk:upsert -s OpportunityLineItem -f data/players.csv -i PlayerId__c -w 2

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not import Battles into Opportunities";
    exit $rc;
fi
echo "Imported Battles successfully"
