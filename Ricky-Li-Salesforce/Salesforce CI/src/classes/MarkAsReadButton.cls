public class MarkAsReadButton {
    
    public Boolean SaveNeeded{get;set;}
    public Boolean showContent { get; set; }  
    public String pageURL{set;}
    
    private final Tour_evaluation__c te1;
    private ApexPages.StandardController teController {get;set;}
    
    Tour_Evaluation__c te;
    public MarkAsReadButton(ApexPages.StandardController controller) {
        //get the Id from URL
        te = [Select Id, User_Read__c, Date_Read__c from Tour_Evaluation__c where Id =:ApexPages.currentPage().getParameters().get('Id')];  
        teController = controller;
        this.te1 = (Tour_Evaluation__c) controller.getRecord();
        showContent = true; 
    }
    public String MarkAsRead(){
        //Validate
        if(te.User_Read__c != null && te.Date_Read__c != null){
            showContent = false;
        }
        else{
            String name = UserInfo.getUserId();
            te.User_Read__c = name;
            te.Date_Read__c = String.valueOf(date.today());
            //System.Debug(te);
            update te;
            SaveNeeded = true;
        }
        return null;
    }
    
    public String getparentURL(){
        PageReference redirectURL = teController.view();
        return redirectURL.getURL();
    }
    
    public String displayButton(){
       if(te.User_Read__c != null && te.Date_Read__c != null)
           showContent = false;
       else 
           showContent = true;
                
       return null;     
    }
}