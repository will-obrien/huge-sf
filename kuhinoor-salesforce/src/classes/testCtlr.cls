public class testCtlr{
    public a__c obj{get;set;}
    public date day{get;set;}
    public date startdate{get;set;} 
    public date endDate{get;set;}
    public testCtlr(){
        startdate = date.today();
        endDate = date.today().adddays(3);
        obj = new a__c();
    }
    
    public void demo(){
        
        if(!isValid()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This is apex:pageMessages'));
        }
        
        
    }
    
    private boolean isValid(){
        boolean isvalid= true;
        if(startdate >= obj.day__c){
            isvalid = false;                  
        }
         if(endDate <= obj.day__c ){
            isvalid = false;                  
        }
        return isvalid;
    }
}