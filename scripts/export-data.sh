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
echo 'sfdx force:data:soql:query -q "SELECT Name, IsActive, Author__r.GithubUserName__c, TankModel__c, Family FROM Product2 WHERE Author__c != null" -r csv > data/tankModels.csv'
sfdx force:data:soql:query -q "SELECT Name, IsActive, Author__r.GithubUserName__c, TankModel__c, Family FROM Product2 WHERE Author__c != null" -r csv > data/tankModels.csv

rc=$?
if [ $rc -ne 0 ]; then
    echo "could not export Tank Models from Products";
    exit $rc;
fi
echo "Exported Tank Models successfully"

echo "Exporting Battles..."
echo 'sfdx force:data:soql:query -q "SELECT Name, StageName, CloseDate, Account.League__c, FieldDefinition__c, MaxRounds__c, InitialLiveLevel__c, BattleId__c FROM Opportunity WHERE Account.League__c != null" -r csv > data/battles.csv'
sfdx force:data:soql:query -q "SELECT Name, StageName, CloseDate, Account.League__c, FieldDefinition__c, MaxRounds__c, InitialLiveLevel__c, BattleId__c FROM Opportunity WHERE Account.League__c != null" -r csv > data/battles.csv
rc=$?
if [ $rc -ne 0 ]; then
    echo "could not export Battles from Opportunities";
    exit $rc;
fi
echo "Exported Battles successfully"

echo "Exporting Battle Participants..."
echo 'afdx force:data:soql:query -q "SELECT BattleHistory__c, PlayerId__c, IsWinner__c, Product2.TankModel__c, Quantity, TotalPrice, Opportunity.BattleId__c, NumberOfLives__c, Score__c FROM OpportunityLineItem WHERE Opportunity.Account.League__c != null" -r csv > data/players.csv'
sfdx force:data:soql:query -q "SELECT PlayerId__c, IsWinner__c, Product2.TankModel__c, Quantity, TotalPrice, Opportunity.BattleId__c, NumberOfLives__c, Score__c FROM OpportunityLineItem WHERE Opportunity.Account.League__c != null" -r csv > data/players.csv
rc=$?
if [ $rc -ne 0 ]; then
    echo "could not export Battle Participants from Opportuniy Line Items";
    exit $rc;
fi
echo "Exported Battles Participants successfully"
