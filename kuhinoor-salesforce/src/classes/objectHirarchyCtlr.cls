/*
    #Name        : objectHirarchyCtlr
    #Date        : 
    #Author      : kuhinoor
    #Description : Clone a record with its child record or related objrct recod ( Example of hirarchy)
*/
Public class objectHirarchyCtlr{
    public String currentRecordId {get;set;}
    
    // -- Constructor Method---
    public objectHirarchyCtlr(ApexPages.StandardController controller){
        
    }
    public void duplicate(){  
        set<id> ids = new set<id>();
        List<lightingprefix__B__c > parantList = new  List<lightingprefix__B__c >();
        List<lightingprefix__C__c > parantList2 = new  List<lightingprefix__C__c >();
        List<lightingprefix__D__c > parantList3 = new  List<lightingprefix__D__c >();          
        currentRecordId = apexPages.currentpage().getParameters().get('id'); 
        
        //------- Insert Object A-------        
        lightingprefix__A__c grandParent = [SELECT Id, Name,lightingprefix__City__c FROM lightingprefix__A__c where id=:currentRecordId];
        lightingprefix__A__c objA =grandParent.clone(false);
        insert objA;  
        
        //------- Insert Object B ( child of object A)-------
        list<lightingprefix__B__c>  objB = [ SELECT Id, Name FROM lightingprefix__B__c where lightingprefix__name__c=:grandParent.id];
        list<lightingprefix__C__c>  objC = [ SELECT Id, Name FROM lightingprefix__C__c where lightingprefix__name__c=:grandParent.id];
        for(lightingprefix__B__c  val : objB ){
            lightingprefix__B__c   temp = val.clone(false,true);
            temp.Name__c= objA.id;
            parantList.add(temp);
        }
        
        //-------- Insert Object C ( child of object A)--------
        for(lightingprefix__C__c  valc: objC ){
            ids.add(valc.id);
            lightingprefix__C__c   temp2 = valc.clone(false,true);
            temp2.Name__c= objA.id;
            parantList2.add(temp2);
        }
       insert parantList;
       insert parantList2;
       
       
       // ----- insert Object D (child of object c)--------
       list<lightingprefix__D__c>  objd = [ SELECT Id, Name FROM lightingprefix__D__c where lightingprefix__name__c IN : ids];
       for(lightingprefix__D__c valD : objd){
           for(lightingprefix__C__c v :parantList2){
                lightingprefix__D__c temp3 = valD.clone(false,true);
                temp3.Name__c =  v.id;
                parantList3.add(temp3);
           }
          
       }
       insert parantList3;
    
       
  }  
}