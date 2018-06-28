public with sharing class Lead3CLogic {

    public String SFID {get;set;}
    private String firstName {get;set;}
    private String lastName {get;set;}
    private String phone {get;set;}
    private String email {get;set;}
    private String stage {get;set;}
    private integer stageScore {get;set;}
    private String product {get;set;}
    private String ownerName {get;set;}
    
    public Lead3CLogic(Opportunity opportunity){
        try{
            this.SFID = opportunity.Id;
            this.firstName = opportunity.Account_First_Name__c;
            this.lastName = opportunity.Account_Last_Name__c;
            this.phone = opportunity.Account_Phone__c;
            this.email = opportunity.Account_Email__c;
            this.stage = opportunity.StageName;
            this.product = opportunity.Product__c;
            this.ownerName = opportunity.Owner_Name__c;
            this.stageScore = (Integer)opportunity.x3Clogic_Stage_Score__c;
        }catch(Exception ex){
            system.debug(ex);
        }
    }
    
    public void updateOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }
    
    public String getSFIDParameter(){
        if(this.SFID != null && this.SFID != ''){
            return '&SFID=' + EncodingUtil.urlEncode(this.SFID, 'UTF-8');
        }else{
            return '';
        }
    }
    
    public String getFirstNameParameter(){
        if(this.firstName != null && this.firstName != ''){
            return '&firstName=' + EncodingUtil.urlEncode(this.firstName, 'UTF-8');
        }else{
            return '';
        }
    }
    
    public String getLastNameParameter(){
        if(this.lastName != null && this.lastName != ''){
            return '&lastName=' + EncodingUtil.urlEncode(this.lastName, 'UTF-8');
        }else{
            return '';
        }
    }
    
    public String getHomePhoneParamter(){
        if(this.phone != null && this.phone != ''){
            String phone = this.phone.replaceAll('\\D','');

            system.debug('Phone: ' + phone);
// AMalena 2014-11-04 3pm - not adding '1' to phone any longer - done in code above.........
            //return '&homePhone=' + EncodingUtil.urlEncode('1' + phone, 'UTF-8');
            return '&homePhone=' + EncodingUtil.urlEncode( phone, 'UTF-8');
// AMalena 2014-11-04 3pm end change

        }else{
            return '';
        }
    }
    
    public String getPhoneParameter(){
        if(this.phone != null && this.phone != ''){
            String phone = this.phone.replaceAll('\\D','');
            system.debug('Phone: ' + phone);
            //return '&phoneNumber=' + EncodingUtil.urlEncode('1' + phone, 'UTF-8');
            return '&phoneNumber=' + EncodingUtil.urlEncode( phone, 'UTF-8');
        }else{
            return '';
        }
    }
    
    public String getResultCodeParameter(){
        return '&resultCode='+EncodingUtil.urlEncode('Not Interested', 'UTF-8');
    }
    
    public String getEmailParameter(){
        if(this.email != null && this.email != ''){
            return '&email=' + EncodingUtil.urlEncode(this.email, 'UTF-8');
        }else{
            return '';
        }
    }
    
    public String getHiddenParameter(){
        return '&hiddenParams=Stage~Stage_Priority';
    }
    
    public String getStageParameter(){
        if(this.stage != null && this.stage != ''){
            return '&Stage=' + EncodingUtil.urlEncode(this.stage, 'UTF-8');
        }else{
            return '';
        }
    }
    
    public String getStagePriorityParameter(){
        if(this.stageScore != null){
            return '&Stage_Priority=' + EncodingUtil.urlEncode(String.valueOf(this.stageScore), 'UTF-8');
        }else{
            return '';
        }
    }
    
    public String getProjectParameter(){
        if(this.product != null && this.product != '' && this.ownerName != null ){
            return '&projectName=' + EncodingUtil.urlEncode('Opp' + ' - ' + this.product + ' - ' + this.ownerName, 'UTF-8');
        }else{
            return '';
        }
    }

}