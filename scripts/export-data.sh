#!/bin/bash

echo "Exporting Leagues definitions..."
echo 'sfdx force:data:soql:query -q "SELECT Name, League__c FROM Account WHERE League__c != null" -r csv > data/leagues.csv'
sfdx force:data:soql:query -q "SELECT Name, League__c FROM Account WHERE League__c != null" -r csv > data/leagues.csv

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not export Leagues definitions from Accounts";
    exit $rc;
fi
echo "Exported Leagues successfully"

echo "Exporting Authors..."
echo 'sfdx force:data:soql:query -q "SELECT LastName, GithubUserName__c FROM Contact WHERE GithubUserName__c != null" -r csv > data/authors.csv'
sfdx force:data:soql:query -q "SELECT LastName, GithubUserName__c FROM Contact WHERE GithubUserName__c != null" -r csv > data/authors.csv

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not export Authors from Contacts";
    exit $rc;
fi
echo "Exported Authors successfully"

echo "Exporting Tank Models..."
echo 'sfdx force:data:soql:query -q "SELECT Name, IsActive, Author__r.GithubUserName__c, TankModel__c FROM Product2 WHERE Author__c != null" -r csv > data/tankModels.csv'
sfdx force:data:soql:query -q "SELECT Name, IsActive, Author__r.GithubUserName__c, TankModel__c FROM Product2 WHERE Author__c != null" -r csv > data/tankModels.csv

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not export Tank Models from Products";
    exit $rc;
fi
echo "Exported Tank Models successfully"
