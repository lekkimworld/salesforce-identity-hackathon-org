# Salesforce Identity Hackathon

## Deploy metadata ##
```
sfdx force:org:create --setdefaultusername -a hackathon -f config/project-scratch-def.json
sfdx force:source:deploy -m ApexPage,ApexClass,StaticResource,CustomObject
sfdx force:data:tree:import -f data/Account.json
sfdx force:community:create --templatename 'Build Your Own' --urlpathprefix hackathon --name 'Salesforce Identity Hackathon' --description 'Experience Cloud Site for Salesforce Identity Hackathon'
```

## In-org Configuration ##
Create Connected App
- Scopes: openid, refresh
- Callback: http://localhost:8080
- Deselect "Require Secret for Web Server Flow"
- Deselect "Require Secret for Refresh Token Flow"
- Save
- Edit policies
- Ensure selected: "Refresh token is valid until revoked"
- Permitted Users: "Admin users are pre-authorized"

User: User User
- Create role and assign to user

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
