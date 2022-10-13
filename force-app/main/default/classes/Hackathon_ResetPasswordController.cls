/**
 * An apex page controller that exposes the site reset password functionality
 */
public with sharing class Hackathon_ResetPasswordController {
    public String reg_password {get; set {reg_password = value == null ? value : value.trim(); } }
    public String reg_confirmPassword {get; set { reg_confirmPassword = value == null ? value : value.trim(); } }
       
    public Hackathon_ResetPasswordController() {}
  
    public PageReference resetPassword() {
      String userId = UserInfo.getUserId();
      if (reg_password.equals(reg_confirmPassword)) {
        System.setPassword(userId, reg_password);
        PageReference page = System.Page.Hackathon_ResetPasswordConfirm;
        page.setRedirect(true);
        return page;
      }
      return null;
    }
}
