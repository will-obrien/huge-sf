public with sharing class SurveyManagerController {
    private ApexPages.StandardController stdControl;
    public Boolean editCSS;
    
    public Boolean getEditCSS(){
        return editCSS;
    } 
    
    public SurveyManagerController(ApexPages.StandardController stdController){
        this.stdControl = stdController;
        
        List<User> res = [SELECT Profile.PermissionsAuthorApex FROM User WHERE id=:Userinfo.getUserId()];
        User u = res[0];
        if(u.Profile.PermissionsAuthorApex){
            this.editCSS = true;
        }else{
            this.editCSS = false;
        }
    }
}