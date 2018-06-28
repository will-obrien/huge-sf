public with sharing class cloneExamDetails
{
    // properites
    public Exam__c tempExamRecord{get;set;}
    ApexPages.StandardController stdController {get;set;}
    
    public cloneExamDetails(ApexPages.StandardController controller) {
            tempExamRecord = (Exam__c)controller.getRecord();
            stdController = controller;
    }
    
    
    public PageReference doCloneExam()
    {
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        
        Exam__c currentExamRecord;
        Exam__c newExamRecord;
        try{
        // fetch the old exam record id  and create a clone of that. before inserting the clone update the cloned_from__c 
        currentExamRecord = [Select Id,name,Deferral_Fee__c,Early_Exam_Registration_Fee__c,Israel_Exam_Date__c,Enrollment_Fee__c,Exam__c,Exam_Request_Change_Fee__c,Exam_Status__c,Late_Exam_Registration_Fee__c,Standard_Exam_Registration_Fee__c,Exam_Date__c from Exam__c where id =:ApexPages.currentPage().getParameters().get('oId') ];
        newExamRecord = currentExamRecord.clone(false);
        newExamRecord.Name = tempExamRecord.Name;
        newExamRecord.Exam_Date__c = tempExamRecord.Exam_Date__c;
        newExamRecord.Israel_Exam_Date__c = tempExamRecord.Israel_Exam_Date__c;
        newExamRecord.Cloned_From__c = currentExamRecord.Id;    
    /**
        if(newExamRecord.Name == currentExamRecord.Name){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a name that is different from the previous record.'));
            return null;
        }
     **/
        // insert the cloned exam record
        try{
        insert newExamRecord;   
        }catch(Exception ex)
        {
            if(ex.getMessage().contains('duplicate'))
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate record. Please check the records in the system.'));
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;                    
        }
        // fetch all the Exam site record for the new examd date
        Map<Id,Id> map_SiteWithSameExamDate = new Map<Id,Id>();
        for(Exam_Sites__c examSites :[Select Site__c,Site__r.Name,Site__r.Cloned_From__c,Site__r.Active__c from Exam_Sites__c where Site__c!=null and Site__r.Active__c=true and ((Exam_Date__c=:newExamRecord.Exam_Date__c and Site__r.Name!='Israel') OR (Exam_Date__c=:newExamRecord.Israel_Exam_Date__c and Site__r.Name='Israel'))])
        {
            map_SiteWithSameExamDate.put(examSites.Site__r.Cloned_From__c,examSites.Site__c);
        }
             
        // fetch all the sites record for old exam record from the exam events object.
        // clone the site records. update the cloned_from__c on the cloned records and add the cloned records to the list.
        List<Site__c> lst_Site = new List<Site__c>();
        for(Exam_Sites__c examSites :[Select Exam__c,Site__c,Site__r.Name,Site__r.Cloned_From__c,Site__r.Non_selectable__c,Site__r.Active__c from Exam_Sites__c where Exam__c=:currentExamRecord.Id and Site__c!=null and Site__r.Active__c=true and ((Exam_Date__c!=:newExamRecord.Exam_Date__c and Site__r.Name!='Israel') OR (Exam_Date__c!=:newExamRecord.Israel_Exam_Date__c and Site__r.Name='Israel'))])
        {
            if(!map_SiteWithSameExamDate.containsKey(examSites.Site__c))
            {
                Site__c s = examSites.Site__r.clone(false);
                s.Cloned_From__c = examSites.Site__c;
                lst_Site.add(s);
            }
        }
        // insert the cloned records.
        Map<String,String> map_oldNewSites = new Map<String,String>();
        if(lst_Site.size()>0)
        {
            insert lst_Site;

            // requery the Sites record to create a map of old and new site id
            
            for(Site__c s:[Select Id,Cloned_From__c from Site__c where Id In:lst_Site])
            {
                map_oldNewSites.put(s.Cloned_From__c,s.Id);
            }
        }
        // query Exam_Sites__c for the exam and clone 
        List<Exam_Sites__c> lst_examSites = new List<Exam_Sites__c>();
        for(Exam_Sites__c es:[Select Cloned_From__c,Site__c,Site__r.Name,Exam__c,Exam_Date__c from Exam_Sites__c where Exam__c =: ApexPages.currentPage().getParameters().get('oId') and Site__c!=null and Site__r.Active__c=true])
        {
            Exam_Sites__c newEs = new Exam_Sites__c(Exam__c = newExamRecord.Id);
            if(es.Site__r.Name =='Israel')
                newEs.Site__c = es.Exam_Date__c==newExamRecord.Israel_Exam_Date__c?es.Site__c:map_SiteWithSameExamDate.containsKey(es.Site__c)? map_SiteWithSameExamDate.get(es.Site__c):map_oldNewSites.get(es.Site__c);
            else    
                newEs.Site__c = es.Exam_Date__c == newExamRecord.Exam_Date__c ? es.Site__c:map_SiteWithSameExamDate.containsKey(es.Site__c)? map_SiteWithSameExamDate.get(es.Site__c):map_oldNewSites.get(es.Site__c);
                
            newEs.Exam_Date__c = es.Site__r.Name =='Israel' ? newExamRecord.Israel_Exam_Date__c:newExamRecord.Exam_Date__c;
            lst_examSites.add(newEs);
        }
            
        insert lst_examSites; 
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
          PageReference p =  new PageReference('/'+newExamRecord.Id+'/e');
           p.getParameters().put('retURL','/'+newExamRecord.Id);
          p.setRedirect(true);
          return p;    
    }
}