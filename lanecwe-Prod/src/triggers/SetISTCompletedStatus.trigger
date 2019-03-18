/*********************************************************************
Name : Test_SetISTCompletedStatus
Created On : jan 09, 2013  
Created By : JP
Description : Used to update a flag field on IST, to trigger the workflow IST_set stage to Cancelled - Implementation cancelled
**********************************************************************/

trigger SetISTCompletedStatus on Opportunity (after insert, after update) {


  
  system.debug('---------I am inside trigger------------ ');
public List<Implementation_Services__c> ImpSerList = new List<Implementation_Services__c>();
public List<Implementation_Services__c> ImpSerUpdateList = new List<Implementation_Services__c>();
public boolean flag=false;

   
 for(Opportunity opp:trigger.new){
    if(opp.Opp_Stage__c=='Closed Lost'){

       system.debug('---------I am Closed state------------ ');
       ImpSerList=[Select id,CheckboxForWFRule__c from Implementation_Services__c where Related_Opportunity__r.id=:opp.id ];
       system.debug('###--------------------- ImpSerList'+ImpSerList);
             
    } 
   }
     
     if(ImpSerList.size()>0 )
     {
       for(Implementation_Services__c II:ImpSerList)
         {  system.debug('###--------------------- II.id'+II.id); 
         system.debug('###--------------------- II.CheckboxForWFRule__c'+II.CheckboxForWFRule__c);
         
          if(flag==II.CheckboxForWFRule__c)
            {
             II.CheckboxForWFRule__c=true;          
             update II; 
            }             
         }
     } 
     
    

 

  }