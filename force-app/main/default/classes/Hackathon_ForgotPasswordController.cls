/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class Hackathon_ForgotPasswordController {
    public String username {get; set;}   
    public String language {get; set;}
       
    public Hackathon_ForgotPasswordController() {
      this.language = ApexPages.currentPage().getParameters().get('language');
      if (String.isEmpty(this.language)) this.language = 'en_US';
    }
  
    public PageReference forgotPassword() {
      boolean success = Site.forgotPassword(username);
      PageReference pr = Page.Hackathon_ForgotPasswordConfirm;
      pr.getParameters().put('language', this.language);
      pr.setRedirect(true);
      
      if (success) {        
        return pr;
      }
      return null;
    }
}
