# Salesforce Identity Hackathon

## Deploy metadata ##
```
sfdx force:org:create --setdefaultusername -a hackathon -f config/project-scratch-def.json
sfdx force:source:deploy -m ApexPage,ApexClass,StaticResource,CustomObject,Role,PermissionSet,CustomLabel,Translations
ROLE_ID=`sfdx force:data:soql:query -q "select Id from UserRole where Name='Dummy'" --json | jq ".result.records[0].Id" -r`
sfdx force:data:record:update -s User -w "Name='User User'" -v "LanguageLocaleKey=en_US TimeZoneSidKey=Europe/Paris LocaleSidKey=da UserPreferencesUserDebugModePref=true UserPreferencesApexPagesDeveloperMode=true UserPermissionsInteractionUser=true UserPermissionsKnowledgeUser=true UserRoleId=$ROLE_ID"
sfdx force:data:tree:import -f data/Account.json
sfdx force:community:create --templatename 'Build Your Own' --urlpathprefix hackathon --name 'Salesforce Identity Hackathon' --description 'Experience Cloud Site for Salesforce Identity Hackathon'
```

## Full In-org Configuration Steps ##
Create Connected App
- Scopes: openid, refresh
- Callback: http://localhost:8080
- Deselect "Require Secret for Web Server Flow"
- Deselect "Require Secret for Refresh Token Flow"
- Save
- Edit policies
- Ensure selected: "Refresh token is valid until revoked"
- Permitted Users: "Admin users are pre-authorized"

Platform Cache
- Create a partition called "Nonce" with some MB allocated under `Org Cache Allocation`

CORS
- Setup CORS for "http://localhost:8080"
- Enable CORS for OAuth endpoints

"External Identity User" Profile
- Access to Connected App

Experience Guest User Profile
- Access to Visualforce Pages
- Access to Apex classes

Experience Cloud Site
- Activate
- Add "External Identity Users" to Members
- Login & Registration
    - Set "Login Page" to Visualforce page
    - Set "Logout Page URL" to "http://localhost:8080"
    - Set "Forgot Password" to Visualforce page
    - Set "Reset Password" to Visualforce page
    - Select "Allow customers and partners to self-register"
    - Set "Registration Page Type" to Visualforce page

## Assisted In-org Configuration Steps ##
```
ORG_ID=`sfdx force:org:display --json | jq ".result.id" -r`
SUFFIX=`echo $ORG_ID`_`date +%s`
CLIENT_ID=hackathon_id_$SUFFIX
CLIENT_SECRET=hackathon_secret_$SUFFIX
mkdir -p force-app/main/default/connectedApps
cat ./metadataTemplates/connectedApps/Hackathon.connectedApp-meta.xml \
    | sed "s|REPLACE_CLIENT_ID|$CLIENT_ID|" \
    | sed "s|REPLACE_CLIENT_SECRET|$CLIENT_SECRET|" \
    > force-app/main/default/connectedApps/Hackathon.connectedApp-meta.xml
sfdx force:source:deploy -m Profile,ConnectedApp,PlatformCachePartition
echo $CLIENT_ID
echo $CLIENT_SECRET
```

Change "External User Profile" to "My External User Profile" in `force-app/main/default/classes/Hackathon_SignupController.cls`.

```
sfdx force:source:deploy -m ApexClass
```

Experience Cloud Site
- Activate
- Add "External Identity Users" to Members
- Login & Registration
    - Set "Login Page" to Visualforce page
    - Set "Logout Page URL" to "http://localhost:8080"
    - Set "Forgot Password" to Visualforce page
    - Set "Reset Password" to Visualforce page
    - Select "Allow customers and partners to self-register"
    - Set "Registration Page Type" to Visualforce page

## Create API Only User ##
```
sfdx force:apex:execute -f apex/create_api_only_user.apex
```
