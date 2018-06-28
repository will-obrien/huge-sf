Public Class examController{
Public String selectedans{get;set;}
Public List<model> models{get;set;}
public String jsList{get;set;}
Public Integer count=0;
Public Integer recordstrcount=0;
    Public examController(){
       models = new  List<model>();
     
       List<lightingprefix__Question__c> record =[select lightingprefix__Question__c,lightingprefix__Option_B__c,lightingprefix__option_A__c from lightingprefix__Question__c];
      
       for(lightingprefix__Question__c val : record ){
           model md = new model();
           List<selectoption> tempList = new List<selectoption>();
           md.ques=val.lightingprefix__Question__c;         
           tempList.add(new selectOption(val.lightingprefix__option_A__c,val.lightingprefix__option_A__c ));
           tempList.add(new SelectOption(val.lightingprefix__Option_B__c,val.lightingprefix__option_B__c));
           md.optList=tempList;     
           models.add(md);     
          }         
      
      
     //  tempList.add(new selectoption());
    }
     Public PageReference test(){
     
       system.debug('######'+jsList);
       list<String> str = new  list<String>();
        str=jsList.split(',');
       
       List<lightingprefix__Question__c> record2 =[select lightingprefix__Ans__c from lightingprefix__Question__c];
       
       list<String> recordstr = new list<String>();
       for(lightingprefix__Question__c val :record2 ){          
           recordstr.add(String.valueOf(val.lightingprefix__Ans__c ));
       }
              
        for(Integer i=0; i<str.size();i++){
         System.debug('**********str-->'+str[i]);
         System.debug('**********recordstr-->'+recordstr[i]);
         if(recordstr[i]==str[i])   
         {      
            count++;
         }
       }
      
        
        System.debug('Count======='+count);
        recordstrcount= record2.size();
        System.debug('recordstrcount======='+recordstrcount);
       // Decimal percent1 = count/recordstrcount ;
        
       // decimal percent = percent1*100;
       // decimal  passpercent = percent;
      //  decimal failpercent =  100-passpercent ;     
       PageReference page = new PageReference('/apex/examControllerpiechart?pass='+Count+'&fail='+recordstrcount);
        
        page.setRedirect(true);        
        return page;
       }
    // ---------wrapper class-----------  
    Public class model{
        Public String ques{get;set;}
        Public list<SelectOption> optList{get;set;}       
    }
   
}