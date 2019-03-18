public with sharing class NextTourLeader {
    Tour_Evaluation_Leader__c tel;
    List <Tour_Evaluation_Leader__c> listTEL = new list <Tour_Evaluation_Leader__c>();
    
    public NextTourLeader(ApexPages.StandardController controller) {
     tel = [SELECT Id, Tour_Evaluation__c FROM Tour_Evaluation_Leader__c
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
     listTEL = [Select Id from Tour_Evaluation_Leader__c where Tour_Evaluation__c =: tel.Tour_Evaluation__c];       
    }
    
    public PageReference NextCEO(){  
      PageReference redirectURL;
          if(listTEL.size() > 1){ 
               System.Debug('first if statement');  
            //Check what number is this id on in the list
            for(integer i =0; i < listTEL.size(); i++){
                
                if(listTEL[i].Id == tel.Id){
                   System.Debug('The value of i'+ i);
                   if(listTEL.size() > i+1){
                      System.Debug(listTEL[i+1].Id);
                      redirectURL = new PageReference('/'+listTEL[i+1].Id);
                   }
                   else{
                      System.Debug('own Id' + tel.Id);
                      redirectURL = new PageReference('/'+tel.Id);
                   }
                }
                
             //   else{
             //       System.Debug('own Id 2ND' + tel.Id);
             //       redirectURL = new PageReference('/'+tel.Id);
             //   }
            }                      
          }
          else
             redirectURL = new PageReference('/'+tel.Id);

      return redirectURL;
    }
    

}