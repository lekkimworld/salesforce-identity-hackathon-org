global virtual with sharing class Hackathon_SigninControllerBase {
    public String expId {get; set;}
    public String language {get; set;}
    global String username {get; set;}
    global String password {get; set;}
    public String orgId {get; set;}
    public String siteURL  {get; set;}
    public String startURL {get; set;}
    public List<AuthProvider> authProviders {get;set;}
    
    global Hackathon_SigninControllerBase (boolean enforceExperienceId) {
        final String expId = System.Site.getExperienceId();
        final integer idx1 = expId.indexOf('_') + 1;
        final integer idx2 = idx1+4;
        this.language = expId.substring(idx1, idx2);
        if (null == this.language) {
            this.language = 'en_US';
        } else {
            this.language = this.language.substring(0, 2) + '_' + this.language.substring(2);
        }
        final String nonce = expId.substring(idx2);

        if (Cache.Org.contains('local.Nonce.' + nonce)) {
            Cache.Org.remove('local.Nonce.' + nonce);
            this.expId = nonce;
        } else {
            return;
        }
        this.orgId = UserInfo.getOrganizationId();
        this.siteURL  = Site.getBaseUrl();
        this.startURL = System.currentPageReference().getParameters().get('startURL');
        if (null == this.startURL) this.startURL = '/';
        this.authProviders = [SELECT Id,DeveloperName,FriendlyName,ProviderType FROM AuthProvider];
    }

    global PageReference login() {
        return Site.login(username, password, startUrl);
    }
    
    global String getEncodedSiteUrl() {
        return EncodingUtil.urlEncode(siteURL, 'UTF-8');
    }
    
    global String getEncodedStartUrl() {
        return EncodingUtil.urlEncode(startURL, 'UTF-8');
    }
    
}
