public with sharing class cloneExamgroupDetails
{
    // properites
    public Exam_Group__c tempExamRecord{get;set;}
    ApexPages.StandardController stdController {get;set;}
    
    public cloneExamgroupDetails(ApexPages.StandardController controller) {
            tempExamRecord = (Exam_Group__c)controller.getRecord();
            stdController = controller;
    }
    
    
    public PageReference doCloneExamGroupHierarchy()
    {
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        
        Exam_Group__c currentExamGrpRecord;
        Exam_Group__c newExamGrpRecord;
        try{
        // fetch the old exam group record and create a clone of that. before inserting the clone update the cloned_from__c 
        currentExamGrpRecord = [Select Id,name,Israle_Exam_Date__c,Exam_Date__c from Exam_Group__c where id =:ApexPages.currentPage().getParameters().get('Id') ];
        newExamGrpRecord = currentExamGrpRecord.clone(false);
        newExamGrpRecord.Name = tempExamRecord.Name;
        newExamGrpRecord.Exam_Date__c = tempExamRecord.Exam_Date__c;
        
        newExamGrpRecord.Cloned_From__c = currentExamGrpRecord.Id;    

        try{
        insert newExamGrpRecord;   
        }catch(Exception ex)
        {
            if(ex.getMessage().contains('duplicate'))
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate record. Please check the records in the system.'));
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;                    
        }
   
        // fetch all the Exam  record related to the exam old exam group and clone
        List<Exam__c> lst_exam = new List<Exam__c>();
        for(Exam__c exam :[Select Id,name,Exam__c,Israel_Exam_Date__c,Exam_Date__c,Cloned_from__c,Exam_Group__c from Exam__c where Exam_Group__c!=null and Exam_Group__c=:currentExamGrpRecord.Id])
        {
            Exam__c e = exam.clone(false);
            e.cloned_from__c = exam.Id;
            e.Exam_Group__c = newExamGrpRecord.Id;
            e.Exam__c = exam.Exam__c;
            e.Exam_Date__c = newExamGrpRecord.Exam_Date__c;
            lst_exam.add(e);
        }
        
        if(lst_exam.size() > 0)
            insert lst_exam;
        
        // requery the exam record to create a map of old and new exam id
        Map<String,String> map_oldNewExam = new Map<String,String>();
        for(Exam__c e:[Select Id,Cloned_From__c from Exam__c where Id In:lst_exam])
        {
            map_oldNewExam.put(e.Cloned_From__c,e.Id);
        }       
        
        // clone the site records. update the cloned_from__c on the cloned records and add the cloned records to the list.
        List<Site__c> lst_Site = new List<Site__c>();
        List<Exam_Sites__c> lst_examSite = new List<Exam_Sites__c>(); 
        Map<Id,Site__c> mapClonedSites = new Map<Id,Site__c>();
        for(Exam_Sites__c examSites :[Select Exam__c,Site__c,Site__r.Name,Site__r.Display_Address__c,Site__r.Site_Code__c,Site__r.Cloned_From__c,Site__r.Non_selectable__c,Site__r.Active__c,Exam_Date__c from Exam_Sites__c where Exam__c IN :map_oldNewExam.keySet() and Site__c!=null and Site__r.Active__c=true])
        {
                Site__c s = examSites.Site__r.clone(false);
                s.Cloned_From__c = examSites.Site__c;
                mapClonedSites.put(examSites.Site__c,s);
                lst_Site.add(s);
                Exam_Sites__c es = examSites.clone(false);
                if(s.Site_code__c =='832')
                    es.Exam_Date__c = tempExamRecord.Exam_Date__c+1;
                else
                    es.Exam_Date__c = tempExamRecord.Exam_Date__c;
                    
                lst_examSite.add(es);
        }
        system.debug('mapClonedSites == '+mapClonedSites);
        system.debug('lst_examSite == '+lst_examSite);
        if(mapClonedSites.size()>0)
            insert mapClonedSites.values();
     /*   
        List<Proctor_Registration__c> lstProctors = new List<Proctor_Registration__c>();
        for(Proctor_Registration__c objProctor : [select id,Type__c,Proctor_First_Name__c,Proctor_Last_Name__c,Proctor_Email__c,Proctor_Type__c,Selected__c,Worked__c,Status__c,Exam_Shipping_State_Provence__c,Exam_Shipping_Country__c,Exam_Shipping_Postal_Code__c,Exam_Shipping_Address_3__c,Exam_Shipping_City__c,Exam_Shipping_Address_1__c,Exam_Shipping_Address_2__c,Confirmed__c,Contact__c,Exam_Group__c,Cloned_From__c,Test_Site__c from Proctor_Registration__c where Test_Site__c in: mapClonedSites.keySet()])
        {
            
            Proctor_Registration__c objClonedRec = objProctor.clone(false);
            system.debug('objClonedRec == '+objClonedRec);
            objClonedRec.Cloned_From__c = objProctor.id;
            objClonedRec.Test_Site__c = mapClonedSites.get(objProctor.Test_Site__c).Id;
            objClonedRec.Exam_Group__c =newExamGrpRecord.Id;
            objClonedRec.Selected__c =false;
            objClonedRec.Worked__c = false;
            objClonedRec.Confirmed__c=false;
            lstProctors.add(objClonedRec);
        }
        system.debug('lstProctors == '+lstProctors);
        if(lstProctors.size() > 0)
            insert lstProctors;*/
        Map<String,String> map_oldNewSites = new Map<String,String>();
        for(Site__c s:[Select Id,Display_Address__c,Active__c,Cloned_From__c from Site__c where Id In:lst_Site and Active__c = true])
        {
            map_oldNewSites.put(s.Cloned_From__c,s.Id);
        }       
        for(Exam_Sites__c es:lst_examSite)
        {
            es.Exam__c = map_oldNewExam.get(es.Exam__c);
            es.Site__c = map_oldNewSites.get(es.Site__c);
        }
        
        if(lst_examSite.size() > 0)
            insert lst_examSite;
            
        // query all the venues for the old sites
        if(lst_Site.size()>0)
        {
            List<Venue__c> lst_venues = new List<Venue__c>();
            for(Venue__c v:[Select Id,Active__c,Address1__c,Address2__c,City__c,Country__c,Phone_No__c,State__c,Name,Site__c from Venue__c where Site__c In:map_oldNewSites.KeySet() and Active__c=true])
            {
                Venue__c cvenue = v.clone(false);
                cvenue.Cloned_From__c = v.Id;
                cvenue.Site__c = map_oldNewSites.get(v.Site__c);
                lst_venues.add(cvenue);
            }
            
            if(lst_venues.size()>0)
                insert lst_venues;
                
            // requery the Venues record to create a map of old and new venue id
            Map<String,String> map_oldNewVenue = new Map<String,String>();
            for(Venue__c v:[Select Id,Cloned_From__c from Venue__c where Id In:lst_venues])
            {
                map_oldNewVenue.put(v.Cloned_From__c,v.Id);
            }
            
            // query all the venues for the old sites
            List<Room__c> lst_rooms = new List<Room__c>();
            for(Room__c r:[Select Name,Venue__c,Phone_No__c,Capacity__c,Active__c from Room__c where Venue__c In:map_oldNewVenue.KeySet() and Active__c = true])
            {
                Room__c room = r.clone(false);
                room.Venue__c = map_oldNewVenue.get(r.Venue__c);
                lst_rooms.add(room);
            }
            
            if(lst_rooms.size()>0)
                insert lst_rooms; 
            
        }
        
        }catch(exception e)
        {
          // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        PageReference p =  new PageReference('/'+newExamGrpRecord.Id+'/e');
        p.getParameters().put('retURL','/'+newExamGrpRecord.Id);
        p.setRedirect(true);
        return p;    
    }
}