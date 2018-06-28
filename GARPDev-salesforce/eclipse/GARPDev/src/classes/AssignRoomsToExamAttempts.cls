global class AssignRoomsToExamAttempts implements Database.Batchable<sObject>, Database.Stateful{
    global String errorMsgs = '';
    global Database.QueryLocator start(Database.BatchableContext BC){
    return Database.getQueryLocator('Select Id,Record_id__c from ExamIds__c');
    
       }
   
    global void execute(Database.BatchableContext BC, List<ExamIds__c> scope){
        try{
        List<String> exam_Ids = new List<String>();
        Map<String,ExamIds__c> map_CustomSetting = ExamIds__c.getAll();
        for(String s: map_CustomSetting.keySet())
        {
            if(map_CustomSetting.get(s).Record_id__c!=null){
                exam_Ids.add(map_CustomSetting.get(s).Record_id__c);
            }
        }
  
        // prepare a set of site id
        Map<Id,List<Site__c>> map_examIdSiteList = new Map<Id,List<Site__c>>();
        Set<Id> set_siteId = new Set<Id>();
        List<Site__c> lst_Sites = new List<Site__c>();
        for(Exam_Sites__c examSite : [Select Site__c,Site__r.Id,Exam__c,Site__r.No_of_Members_Enrolled_for_ERP__c,Site__r.No_of_Members_Enrolled_for_FRM1_2__c,Site__r.No_of_Members_Enrolled_for_FRM1_Only__c,Site__r.No_of_Members_Enrolled_for_FRM_2_Only__c from Exam_Sites__c where Exam__c In:exam_Ids and Site__r.No_of_Exam_Attempts__c>0])
        {
            List<Site__c> lst = map_examIdSiteList.containsKey(examSite.Exam__c)?map_examIdSiteList.get(examSite.Exam__c):new List<Site__c>();
            lst.add(examSite.Site__r);
            set_siteId.add(examSite.Site__c);
            map_examIdSiteList.put(examSite.Exam__c,lst);
            lst_Sites.add(examSite.Site__r);
        }
        
        // get all the rooms related to sites
        Map<Id,List<Room__c>> map_siteRooms = new Map<Id,List<Room__c>>();
        for(Room__c room :[Select Id,Name,Capacity__c,Venue__r.Site__c,Venue__r.Site__r.Name from Room__c where Venue__r.Site__c In:set_siteId and Capacity__c > 0 and Venue__r.Site__r.Active__c = true and Active__c = true])
        {
            List<Room__c> lst = map_siteRooms.containsKey(room.Venue__r.Site__c)? map_siteRooms.get(room.Venue__r.Site__c):new List<Room__c>();
            lst.add(room);
            map_siteRooms.put(room.Venue__r.Site__c,lst);
        }
        
        // get the exam attempts for the exams and prepare map with SiteAndExam section as key and values as list of exam attempts
        Map<String,List<Exam_Attempt__c>> map_ERPSiteExamAttempts = new Map<String,List<Exam_Attempt__c>>();
        Map<String,List<Exam_Attempt__c>> map_FRM12SiteExamAttempts = new Map<String,List<Exam_Attempt__c>>();
        Map<String,List<Exam_Attempt__c>> map_FRM1SiteExamAttempts = new Map<String,List<Exam_Attempt__c>>();
        Map<String,List<Exam_Attempt__c>> map_FRM2SiteExamAttempts = new Map<String,List<Exam_Attempt__c>>();
        Map<Id,Set<Id>> map_FRMSiteMembers = new Map<Id,Set<Id>>();
        
        for(Exam_Attempt__c ea:[Select Exam_Site__r.Site__c,Section__c,Room__c,Member__c from Exam_Attempt__c where Exam_Site__r.Exam__c In:exam_Ids and Member__c!=null order by Member__c,Section__c])
        {
            if(ea.Section__c == 'ERP'){
                
                List<Exam_Attempt__c> lst = map_ERPSiteExamAttempts.containsKey(ea.Exam_Site__r.Site__c)?map_ERPSiteExamAttempts.get(ea.Exam_Site__r.Site__c):new List<Exam_Attempt__c>();
                lst.add(ea);
                map_ERPSiteExamAttempts.put(ea.Exam_Site__r.Site__c,lst);
            }
            else
            {
                System.debug(ea.Exam_Site__r.Site__c+' && '+ea.Member__c+' &&& '+ea.Section__c);
                Set<Id> setId = map_FRMSiteMembers.containsKey(ea.Exam_Site__r.Site__c)?map_FRMSiteMembers.get(ea.Exam_Site__r.Site__c):new Set<Id>();
                setId.add(ea.Member__c);
                map_FRMSiteMembers.put(ea.Exam_Site__r.Site__c,setId);
                
                if(ea.Section__c == 'FRM Part 1')
                {
                   if(map_FRM2SiteExamAttempts.containsKey(ea.Member__c))
                    {
                        // delete the member from FRM1 map and add to FRM12 else add to FRM2
                        map_FRM12SiteExamAttempts.put(ea.Member__c,map_FRM2SiteExamAttempts.get(ea.Member__c));
                        List<Exam_Attempt__c> lst = map_FRM12SiteExamAttempts.containsKey(ea.Member__c)?map_FRM12SiteExamAttempts.get(ea.Member__c):new List<Exam_Attempt__c>();
                        lst.add(ea);
                        map_FRM12SiteExamAttempts.put(ea.Member__c,lst); 
                        map_FRM2SiteExamAttempts.remove(ea.Member__c);
                                
                    }                   
                    else{
                        List<Exam_Attempt__c> lst = map_FRM1SiteExamAttempts.containsKey(ea.Member__c)?map_FRM1SiteExamAttempts.get(ea.Member__c):new List<Exam_Attempt__c>();
                        lst.add(ea);
                        map_FRM1SiteExamAttempts.put(ea.Member__c,lst);

                    }}
                else if(ea.Section__c == 'FRM Part 2')
                {
                    if(map_FRM1SiteExamAttempts.containsKey(ea.Member__c))
                    {
                        // delete the member from FRM1 map and add to FRM12 else add to FRM2
                        map_FRM12SiteExamAttempts.put(ea.Member__c,map_FRM1SiteExamAttempts.get(ea.Member__c));
                        List<Exam_Attempt__c> lst = map_FRM12SiteExamAttempts.containsKey(ea.Member__c)?map_FRM12SiteExamAttempts.get(ea.Member__c):new List<Exam_Attempt__c>();
                        lst.add(ea);
                        map_FRM12SiteExamAttempts.put(ea.Member__c,lst); 
                        map_FRM1SiteExamAttempts.remove(ea.Member__c);
                    }
                    else
                    {
                        List<Exam_Attempt__c> lst = map_FRM2SiteExamAttempts.containsKey(ea.Member__c)?map_FRM2SiteExamAttempts.get(ea.Member__c):new List<Exam_Attempt__c>();
                        lst.add(ea);
                        map_FRM2SiteExamAttempts.put(ea.Member__c,lst);
                    }}}}
                    
        List<Exam_Attempt__c> lst2Update = new List<Exam_Attempt__c>();
            //get list of sites for the exam
            
        for(Site__c site :lst_Sites)
        {   System.debug('Site Id :'+site.Id);
            List<Room__c> lst_room = map_siteRooms.containsKey(site.Id)?map_siteRooms.get(site.Id):new List<Room__c>();
            List<RoomWrapper> lst_Wrapper = new List<RoomWrapper>();
            
            if(lst_Room.size()>0)
            {
                for(Room__c rm:lst_room)
                    lst_Wrapper.add(new RoomWrapper(rm));
            }                   
           
            
            if(site.No_of_Members_Enrolled_for_ERP__c!=null && lst_room.size()>0)
            {

                // for the site get the ERP numbers
                Decimal noOfERPAttempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_ERP__c);
                if(noOfERPAttempts>0) // if ERP attempts are gretaer than 0, then continue assiging the rooms
                {
                    //boolean isRoomAvailableWithCapacity = false;
                    Decimal assignedCapacity = 0;
                    
                    System.debug('noOfERPAttempts '+noOfERPAttempts);
                    // loop over the rooms to find the room that has capacity >= noOfERPAttempts
                    for(integer j=0;j!=noOfERPAttempts;j++)
                    {
                        System.debug('before allocation start assignedCapacity '+assignedCapacity+' noOfERPAttempts'+noOfERPAttempts+' lst_Wrapper '+lst_Wrapper.size());
                        assignedCapacity = ExamAllocationUtil.assignOneRoom(site.Id,noOfERPAttempts,lst_Wrapper,map_ERPSiteExamAttempts,lst2Update,assignedCapacity);
                        System.debug('After one room allocation assignedCapacity '+assignedCapacity+' noOfERPAttempts'+noOfERPAttempts+' lst_Wrapper '+lst_Wrapper.size());
                        if(assignedCapacity!=noOfERPAttempts)
                        {
                            lst_Wrapper.sort();
                            Integer i = lst_Wrapper.size()-1;
                            RoomWrapper rw;
                            boolean methodCalled = false;
                            for(RoomWrapper rmw : lst_Wrapper)
                            {
                                rw = lst_Wrapper[i];
                                if(rw.room.Capacity__c>0 && !methodCalled){
                                    System.debug('assignMultipleRooms before allocation start assignedCapacity '+assignedCapacity+' noOfERPAttempts'+noOfERPAttempts+' lst_Wrapper '+lst_Wrapper.size());                                       
                                    assignedCapacity = ExamAllocationUtil.assignMultipleRooms(site.Id,noOfERPAttempts,rw,map_ERPSiteExamAttempts,lst2Update,assignedCapacity);
                                    System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfERPAttempts'+noOfERPAttempts+' lst_Wrapper '+lst_Wrapper.size());
                                    methodCalled = true;
                                    }
                                else
                                    i--;
                            }
                        }else 
                            break;
                    }}}
                    
            //site.No_of_Members_Enrolled_for_FRM1_2__c = null;
            if(site.No_of_Members_Enrolled_for_FRM1_2__c!=null && lst_room.size()>0)
            {
                Decimal noOfFRM12Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM1_2__c);
                if(noOfFRM12Attempts>0)
                {
                    Decimal assignedCapacity = 0;
                    for(integer j=0;j!=noOfFRM12Attempts;j++)   
                    {
                        assignedCapacity = ExamAllocationUtil.assignOneRoomFRM12(site.Id,noOfFRM12Attempts,lst_Wrapper,map_FRMSiteMembers,map_FRM12SiteExamAttempts,lst2Update,assignedCapacity);  
                        if(assignedCapacity!=noOfFRM12Attempts)
                        {
                            lst_Wrapper.sort();
                            Integer i = lst_Wrapper.size()-1;
                            RoomWrapper rw;
                            boolean methodCalled = false;
                            for(RoomWrapper rmw : lst_Wrapper)
                            {
                                rw = lst_Wrapper[i];
                                if(rw.room.Capacity__c>0 && !methodCalled){
                                    System.debug('assignMultipleRooms before allocation start assignedCapacity '+assignedCapacity+' noOfFRM12Attempts'+noOfFRM12Attempts+' lst_Wrapper '+lst_Wrapper.size());                                       
                                    assignedCapacity = ExamAllocationUtil.assignMultipleRoomsFRM12(site.Id,noOfFRM12Attempts,rw,map_FRMSiteMembers,map_FRM12SiteExamAttempts,lst2Update,assignedCapacity);
                                    System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfFRM12Attempts'+noOfFRM12Attempts+' lst_Wrapper '+lst_Wrapper.size());
                                    methodCalled = true;
                                    }
                                else
                                    i--;
                                    }
                        }else 
                            break;
                    }}}
                    
            List<RoomWrapper> lst_Wrapper_2 = new List<RoomWrapper>();
            List<Room__c> lst_room_2 = new List<Room__c>();
            
            if(lst_Wrapper.size()>0)
            {
                for(RoomWrapper rw:lst_Wrapper)
                    lst_room_2.add(rw.room);
                    
                for(Room__c rm:lst_room_2.deepClone(true,false,false))
                    lst_Wrapper_2.add(new RoomWrapper(rm));
            }
            
            if(site.No_of_Members_Enrolled_for_FRM1_Only__c!=null && lst_room.size()>0)
            {
                Decimal noOfFRM1Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM1_Only__c);
                if(noOfFRM1Attempts>0)  
                {
                    Decimal assignedCapacity = 0;
                    for(integer j=0;j!=noOfFRM1Attempts;j++)    
                    {
                        assignedCapacity = ExamAllocationUtil.assignOneRoomFRM1OR2(site.Id,noOfFRM1Attempts,lst_Wrapper,map_FRMSiteMembers,map_FRM1SiteExamAttempts,lst2Update,assignedCapacity);
                        if(assignedCapacity!=noOfFRM1Attempts)
                        {
                            lst_Wrapper.sort();
                            Integer i = lst_Wrapper.size()-1;
                            RoomWrapper rw;
                            boolean methodCalled = false;
                            for(RoomWrapper rmw : lst_Wrapper)
                            {
                                rw = lst_Wrapper[i];
                                if(rw.room.Capacity__c>0 && !methodCalled){
                                    System.debug('assignMultipleRooms before allocation start assignedCapacity '+assignedCapacity+' noOfFRM1Attempts'+noOfFRM1Attempts+' lst_Wrapper '+lst_Wrapper.size());                                       
                                    assignedCapacity = ExamAllocationUtil.assignMultipleRoomsFRM1OR2(site.Id,noOfFRM1Attempts,rw,map_FRMSiteMembers,map_FRM1SiteExamAttempts,lst2Update,assignedCapacity);
                                    System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfFRM1Attempts'+noOfFRM1Attempts+' lst_Wrapper '+lst_Wrapper.size());
                                    methodCalled = true;
                                    }
                                else
                                    i--;
                            }
                        }else 
                            break;
                    }}}
                        
            if(site.No_of_Members_Enrolled_for_FRM_2_Only__c!=null && lst_room.size()>0)
            {
                Decimal noOfFRM2Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM_2_Only__c);
                if(noOfFRM2Attempts>0)  
                {
                    Decimal assignedCapacity = 0;
                    for(integer j=0;j!=noOfFRM2Attempts;j++)    
                    {
                        assignedCapacity = ExamAllocationUtil.assignOneRoomFRM1OR2(site.Id,noOfFRM2Attempts,lst_Wrapper_2,map_FRMSiteMembers,map_FRM2SiteExamAttempts,lst2Update,assignedCapacity);
                        if(assignedCapacity!=noOfFRM2Attempts)
                        {
                            lst_Wrapper_2.sort();
                            Integer i = lst_Wrapper_2.size()-1;
                            RoomWrapper rw;
                            boolean methodCalled = false;
                            for(RoomWrapper rmw : lst_Wrapper_2)
                            {
                                rw = lst_Wrapper_2[i];
                                if(rw.room.Capacity__c>0 && !methodCalled){
                                    System.debug('assignMultipleRooms before allocation start assignedCapacity '+assignedCapacity+' noOfFRM2Attempts'+noOfFRM2Attempts+' lst_Wrapper_2 '+lst_Wrapper_2.size());                                       
                                    assignedCapacity = ExamAllocationUtil.assignMultipleRoomsFRM1OR2(site.Id,noOfFRM2Attempts,rw,map_FRMSiteMembers,map_FRM2SiteExamAttempts,lst2Update,assignedCapacity);
                                    System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfFRM2Attempts'+noOfFRM2Attempts+' lst_Wrapper_2 '+lst_Wrapper_2.size());
                                    methodCalled = true;
                                    }
                                else
                                    i--;
                            }
                        }else 
                            break;
                    }}}}
                    
        if(lst2Update.size()>0){
            List<Database.SaveResult> updateResults = Database.update(lst2Update, false);
            for(Integer i=0;i<updateResults.size();i++){
                if (!updateResults.get(i).isSuccess())
                {
                    // DML operation failed
                    Database.Error error = updateResults.get(i).getErrors().get(0);
                    errorMsgs += '\n Error Updating :'+lst2Update.get(i).Id+' Error Message:'+error.getMessage();
                    //lst2Update.get(i);//failed record from the list
                }}}}
                
            Catch(Exception e){
        errorMsgs += '\n'+e.getMessage();
    }}

    global void finish(Database.BatchableContext BC){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'vvkathi@gmail.com'});
        mail.setReplyTo('noreply@garp.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        if(errorMsgs !='')
            mail.setPlainTextBody('Batch Process has been completed with below errors '+errorMsgs);
        
        else
            mail.setPlainTextBody('Batch Process has been completed successfully.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }}