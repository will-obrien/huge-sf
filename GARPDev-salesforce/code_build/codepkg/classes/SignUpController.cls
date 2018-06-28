/*********************************************
Name: SignUpController
Description: VF controller for custom Community new user sign up page
    
Created/Modified By        Created/Modified Date        Comments
---------------------------------------------------------------------------
1. Billy Meyers             09/17/2014                   Version 1.0
*********************************************/
global without sharing class SignUpController {

    global String firstName {get; set;}
    global String lastName {get; set;}
    global String email {get; set;}
    
    global String action {get; set;}
    global String actionId {get; set;}
    
    global SignUpController() {
        action = ApexPages.currentPage().getParameters().get('action');
        actionId = ApexPages.currentPage().getParameters().get('id');
    }
    
    global PageReference register() {
        System.SavePoint sp = Database.setSavePoint();
        Id leadId;
        Id orderId;
        try {
            TempAccount userData = getUserData();
            if (Registration.GetMember(userData)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The email you provided is already in our system. Please log in instead.'));
                return null;
            } else {
                leadId = Registration.SetLead(userData);
                if (leadId != null) {
                    userData.Id = leadId;
                    //orderId = Registration.createOrder(userData);
                    //if (orderId != null) {
                    if(Registration.createOrder(userData) != null){
                        PageReference pr = Page.SignupConfirm;
                        if(action != null) {
                            if(action == 'meeting'){
                                Lead convertedLead = [SELECT ConvertedContactId FROM Lead where id =: userData.Id];
                                pr.getParameters().put('action', action);
                                pr.getParameters().put('id', actionId);
                                pr.getParameters().put('success', String.valueOf(Registration.chapterMeetingRegister(convertedLead.ConvertedContactId, actionId, true)));
                            } else if (action == 'jobtarget'){
                                Lead convertedLead = [SELECT ConvertedContactId FROM Lead where id =: userData.Id];
                                pr.getParameters().put('action', action);
                                pr.getParameters().put('id', convertedLead.ConvertedContactId);
                            }
                        }
                        return pr;
                    }                  
                }
            }       
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            Database.rollback(sp);
            return null;
        }               
        
        //If it makes it to this point, something went wrong
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an unexpected error.'));
        System.debug('Error registering new user. leadId is ' + leadId + ', orderId is ' + orderId); 
        Database.rollback(sp);
        return null;
    }
    
    global PageReference goToLoginPage() {
        PageReference pr = new PageReference('https://build-garpbuild.cs16.force.com/');
        if(action != null) {
            pr.getParameters().put('action', action);
        }
        if (actionId != null) {
            pr.getParameters().put('id', actionId);
        }
        pr.setRedirect(true);
        return pr;
    }
    
    private TempAccount getUserData(){
        TempAccount objData = new TempAccount();
        objData.FirstName = firstName;
        objData.LastName = lastName;
        objData.Email = email;
        objData.Membership_Type = 'AFREE';
        objData.garpMembership_Type = 'AFREE';
        objData.ACCA = false;
        objData.CA = false;
        objData.CFA = false;
        objData.CMA = false;
        objData.CPA = false;
        objData.InSchool = false;
        objData.OtherDesignation = false;
        objData.PMP = false;
        objData.autoRenew = false;
        objData.erpSwitch = false;
        objData.frmSwitch = false;
        objData.graduationDate = 'Invalid Date';
        objData.hasBooks = false;
        objData.isErpChecked = false;
        objData.isFbrChecked = false;
        objData.isFrmChecked = false;
        objData.isIcbrChecked = false;
        objData.isStudentChecked = false;
        objData.productcode = new List<String>(); 
        TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
        productDefition.GLCode = '4999';
        productDefition.ProductCode = 'AFREE';
        objData.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
        objData.siteName = 'undefined';
        objData.isWorking = false;
        objData.jobTarget = false;       
        objData.referral = 'Bloomberg Terminal';
        objData.sameShip = 'true';
        objData.switchFeeEnabled = false;
        return objData;
    }
}