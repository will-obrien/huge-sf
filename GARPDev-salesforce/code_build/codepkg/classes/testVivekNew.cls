public class testVivekNew // Rob updated to eliminate conflict with standard test classes
{
    public void testM()
    {    
        List<String> exam_Ids = new List<String>();
        Map<String,String> map_exam2Type = new Map<String,String>();
        Map<String,ExamIds__c> map_CustomSetting = ExamIds__c.getAll();
        for(String s: map_CustomSetting.keySet())
        {
            if(map_CustomSetting.get(s).Record_id__c!=null){
                exam_Ids.add(map_CustomSetting.get(s).Record_id__c);
                map_exam2Type.put(map_CustomSetting.get(s).Record_id__c,map_CustomSetting.get(s).Name);
            }
        }
        
        //Map<String,String> map_exam2Type = new Map<String,String>();
        //map_exam2Type.put('a0ye0000000cFAB','ERP');
        //List<String> exam_Ids = new List<String>{'a0ye0000000cFAB'};
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
        for(Room__c room :[Select Id,Name,Capacity__c,Venue__r.Site__c,Venue__r.Site__r.Name from Room__c where Venue__r.Site__c In:set_siteId and Capacity__c > 0])
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
        Map<Id,Set<Id>> map_FRM12SiteMembers = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> map_FRM1SiteMembers = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> map_FRM2SiteMembers = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> map_FRMSiteMembers = new Map<Id,Set<Id>>();
        for(Exam_Attempt__c ea:[Select Exam_Site__r.Site__c,Section__c,Room__c,Member__c from Exam_Attempt__c where Exam_Site__r.Exam__c In:exam_Ids and Member__c!=null order by Member__c,Section__c])
        {
            if(ea.Section__c == 'ERP'){
                //String s = ea.Exam_Site__r.Site__c+ea.Section__c;
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
                                       
                        
                        map_FRM12SiteMembers.put(ea.Exam_Site__r.Site__c,map_FRM2SiteMembers.get(ea.Exam_Site__r.Site__c));   

                        map_FRM2SiteExamAttempts.remove(ea.Member__c);
                        
                                
                    }                   
                    else{
                        List<Exam_Attempt__c> lst = map_FRM1SiteExamAttempts.containsKey(ea.Member__c)?map_FRM1SiteExamAttempts.get(ea.Member__c):new List<Exam_Attempt__c>();
                        lst.add(ea);
                        map_FRM1SiteExamAttempts.put(ea.Member__c,lst);

                    }                   
                }else if(ea.Section__c == 'FRM Part 2')
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
                           
                    }
                    
                }
            }
        }

     

        List<Exam_Attempt__c> lst2Update = new List<Exam_Attempt__c>();
            //get list of sites for the exam
            
            //List<Site__c> lst_Sites = map_examIdSiteList.get('a0ye0000000cFAB');   
            for(Site__c site :lst_Sites)
            {   System.debug('Site Id :'+site.Id);
                List<Room__c> lst_room = map_siteRooms.containsKey(site.Id)?map_siteRooms.get(site.Id):new List<Room__c>();
                List<RoomWrapper> lst_Wrapper = new List<RoomWrapper>();
                if(lst_Room.size()>0)
                {
                    for(Room__c rm:lst_room)
                        lst_Wrapper.add(new RoomWrapper(rm));
                        
                    //lst_Wrapper.sort(); 
                }                   
               
                
                if(site.No_of_Members_Enrolled_for_ERP__c!=null && lst_room.size()>0)
                {

                    // for the site get the ERP numbers
                    Decimal noOfERPAttempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_ERP__c);
                    if(noOfERPAttempts>0) // if ERP attempts are gretaer than 0, then continue assiging the rooms
                    {
                        //boolean isRoomAvailableWithCapacity = false;
                        Decimal assignedCapacity = 0;
                        //String examType = map_exam2Type.get('a0ye0000000cFAB');
                        System.debug('noOfERPAttempts '+noOfERPAttempts);
                        // loop over the rooms to find the room that has capacity >= noOfERPAttempts
                        for(integer j=0;j!=noOfERPAttempts;j++)
                        {
                            System.debug('before allocation start assignedCapacity '+assignedCapacity+' noOfERPAttempts'+noOfERPAttempts+' lst_Wrapper '+lst_Wrapper.size());
                            assignedCapacity = assignOneRoom(site.Id,noOfERPAttempts,lst_Wrapper,map_ERPSiteExamAttempts,lst2Update,assignedCapacity);
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
                                        assignedCapacity = assignMultipleRooms(site.Id,noOfERPAttempts,rw,map_ERPSiteExamAttempts,lst2Update,assignedCapacity);
                                        System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfERPAttempts'+noOfERPAttempts+' lst_Wrapper '+lst_Wrapper.size());
                                        methodCalled = true;
                                        }
                                    else
                                        i--;
                                }
                            }else 
                                break;
                        }
                                       
                    }
                    //}
                    
                }
                //site.No_of_Members_Enrolled_for_FRM1_2__c = null;
                if(site.No_of_Members_Enrolled_for_FRM1_2__c!=null && lst_room.size()>0)
                {
                    Decimal noOfFRM12Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM1_2__c);
                    if(noOfFRM12Attempts>0)
                    {
                        Decimal assignedCapacity = 0;
                        for(integer j=0;j!=noOfFRM12Attempts;j++)   
                        {
                            assignedCapacity = assignOneRoomFRM12(site.Id,noOfFRM12Attempts,lst_Wrapper,map_FRMSiteMembers,map_FRM12SiteExamAttempts,lst2Update,assignedCapacity);  
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
                                        assignedCapacity = assignMultipleRoomsFRM12(site.Id,noOfFRM12Attempts,rw,map_FRMSiteMembers,map_FRM12SiteExamAttempts,lst2Update,assignedCapacity);
                                        System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfFRM12Attempts'+noOfFRM12Attempts+' lst_Wrapper '+lst_Wrapper.size());
                                        methodCalled = true;
                                        }
                                    else
                                        i--;
                                }
                            }else 
                                break;
                        }                       
                    }                   
                }
                
                if(site.No_of_Members_Enrolled_for_FRM1_Only__c!=null && lst_room.size()>0)
                {
                    Decimal noOfFRM1Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM1_Only__c);
                    if(noOfFRM1Attempts>0)  
                    {
                        Decimal assignedCapacity = 0;
                        for(integer j=0;j!=noOfFRM1Attempts;j++)    
                        {
                            assignedCapacity = assignOneRoomFRM1OR2(site.Id,noOfFRM1Attempts,lst_Wrapper,map_FRMSiteMembers,map_FRM1SiteExamAttempts,lst2Update,assignedCapacity);
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
                                        assignedCapacity = assignMultipleRoomsFRM1OR2(site.Id,noOfFRM1Attempts,rw,map_FRMSiteMembers,map_FRM1SiteExamAttempts,lst2Update,assignedCapacity);
                                        System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfFRM1Attempts'+noOfFRM1Attempts+' lst_Wrapper '+lst_Wrapper.size());
                                        methodCalled = true;
                                        }
                                    else
                                        i--;
                                }
                            }else 
                                break;
                        }                       
                    }                   
                }
                
                
                if(site.No_of_Members_Enrolled_for_FRM_2_Only__c!=null && lst_room.size()>0)
                {
                    Decimal noOfFRM2Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM1_Only__c);
                    if(noOfFRM2Attempts>0)  
                    {
                        Decimal assignedCapacity = 0;
                        for(integer j=0;j!=noOfFRM2Attempts;j++)    
                        {
                            assignedCapacity = assignOneRoomFRM1OR2(site.Id,noOfFRM2Attempts,lst_Wrapper,map_FRMSiteMembers,map_FRM2SiteExamAttempts,lst2Update,assignedCapacity);
                            if(assignedCapacity!=noOfFRM2Attempts)
                            {
                                lst_Wrapper.sort();
                                Integer i = lst_Wrapper.size()-1;
                                RoomWrapper rw;
                                boolean methodCalled = false;
                                for(RoomWrapper rmw : lst_Wrapper)
                                {
                                    rw = lst_Wrapper[i];
                                    if(rw.room.Capacity__c>0 && !methodCalled){
                                        System.debug('assignMultipleRooms before allocation start assignedCapacity '+assignedCapacity+' noOfFRM2Attempts'+noOfFRM2Attempts+' lst_Wrapper '+lst_Wrapper.size());                                       
                                        assignedCapacity = assignMultipleRoomsFRM1OR2(site.Id,noOfFRM2Attempts,rw,map_FRMSiteMembers,map_FRM2SiteExamAttempts,lst2Update,assignedCapacity);
                                        System.debug('assignMultipleRooms after allocation start assignedCapacity '+assignedCapacity+' noOfFRM2Attempts'+noOfFRM2Attempts+' lst_Wrapper '+lst_Wrapper.size());
                                        methodCalled = true;
                                        }
                                    else
                                        i--;
                                }
                            }else 
                                break;
                        }                       
                    }                   
                }               
            }

            if(lst2Update.size()>0)
                update lst2Update;
    }
    
    private Decimal assignOneRoom(String siteId,Decimal ERPCnt,List<RoomWrapper> Wrapperlst,Map<String,List<Exam_Attempt__c>> mapSiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        Wrapperlst.sort();
        for(RoomWrapper rw:Wrapperlst) 
        {   System.debug('Capacity :'+rw.room.Capacity__c+' ERP Attempts: '+ERPCnt);
            if(rw.room.Capacity__c >= (ERPCnt - capacityAssigned))
            {
                //isRoomAvailableWithCapacity = true;
                System.debug('Exam Attempts :'+mapSiteExamAttempts.get(siteId).size());
                // get all the exam attempts records and upate them with room Id
                for(Exam_Attempt__c exAtt:mapSiteExamAttempts.get(siteId))
                {
                    if(exAtt.Room__c==null) {
                        System.debug('assignedCap inside assignOneRoom'+capacityAssigned);
                        exAtt.Room__c = rw.room.Id;
                        ExAttUpdate.add(exAtt);
                        rw.room.Capacity__c = rw.room.Capacity__c -1;
                        capacityAssigned++;
                    }
                }
            }
        } 
        return capacityAssigned;        
    }
    
    private Decimal assignMultipleRooms(String siteId,Decimal ERPCnt,RoomWrapper roomWrapper,Map<String,List<Exam_Attempt__c>> mapSiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        
        
        //System.debug('lst_Wrapper.size(): '+(Wrapperlst.size()-1));
        //Integer i = Wrapperlst.size()-1;
        //for(RoomWrapper rmw : Wrapperlst)
        //{
            RoomWrapper rw = roomWrapper;
            
            if(capacityAssigned != ERPCnt && rw.room.Capacity__c>0){
                
                System.debug('Exam Attempts :'+mapSiteExamAttempts.get(siteId).size());
                for(Exam_Attempt__c exAtt:mapSiteExamAttempts.get(siteId))
                {   
                    if(exAtt.Room__c==null && rw.room.Capacity__c>0) {
                        System.debug('assignedCap inside assignMultipleRooms'+capacityAssigned);
                        exAtt.Room__c = rw.room.Id;
                        ExAttUpdate.add(exAtt);
                        rw.room.Capacity__c = rw.room.Capacity__c -1;
                        capacityAssigned++;
                    }
                } 
                //i--;                                    
                
            }
            return capacityAssigned;
               
    }   

    private Decimal assignOneRoomFRM12(String siteId,Decimal FRM12Cnt,List<RoomWrapper> Wrapperlst,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_FRM12SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        Wrapperlst.sort();
        
        System.debug('Rooms for site '+Wrapperlst.size());
        // loop over the rooms to find the room that has capacity >= FRM12Cnt
        for(RoomWrapper rw:Wrapperlst) 
        {   System.debug('Room Capacity :'+rw.room.Capacity__c+' FRM12 Attempts: '+FRM12Cnt);
            if(rw.room.Capacity__c > 0 && rw.room.Capacity__c >= (FRM12Cnt - capacityAssigned))
            {
                // get all the exam attempts records and upate them with room Id
                System.debug('members for site :'+map_FRMSiteMembers.get(siteId).size());
                for(Id memId:map_FRMSiteMembers.get(siteId)) 
                {   System.debug('member Id :'+memId);
                    if(map_FRM12SiteExamAttempts.containsKey(memId))
                    {   System.debug('Exam Attempts '+map_FRM12SiteExamAttempts.get(memId).size());
                        for(Exam_Attempt__c exAtt:map_FRM12SiteExamAttempts.get(memId))
                        {
                            if(exAtt.Room__c==null){
                                exAtt.Room__c = rw.room.Id;
                                ExAttUpdate.add(exAtt);
                            }
                        }
                    rw.room.Capacity__c = rw.room.Capacity__c - 1; 
                    capacityAssigned++;
                    }
                }
            }
        }
        return capacityAssigned;        
    }
    
    
    private Decimal assignMultipleRoomsFRM12(String siteId,Decimal FRM12Cnt,RoomWrapper roomWrapper,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_FRM12SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        // now start form the bootom of the Wrapperlst and assign rooms to the exam attempts
        Decimal count = 0;
        //System.debug('Wrapperlst.size(): '+(Wrapperlst.size()-1));
        RoomWrapper rw = roomWrapper;
        if(capacityAssigned != FRM12Cnt && rw.room.Capacity__c>0){
                
        System.debug('Room '+rw.room.Name+' Capacity'+rw.room.Capacity__c);
        // get the members
        
            for(Id memId:map_FRMSiteMembers.get(siteId)) 
            {   System.debug('memId**'+memId);
                if(map_FRM12SiteExamAttempts.containsKey(memId))
                {
                    for(Exam_Attempt__c exAtt:map_FRM12SiteExamAttempts.get(memId))
                    {
                        if(exAtt.Room__c==null) {
                            exAtt.Room__c = rw.room.Id;
                            ExAttUpdate.add(exAtt);
                        }
                    }
                    rw.room.Capacity__c = rw.room.Capacity__c -1;
                    capacityAssigned++;
                    map_FRM12SiteExamAttempts.remove(memId);
                }
            }
        }
        return capacityAssigned;
    }

        private Decimal assignOneRoomFRM1OR2(String siteId,Decimal FRM1Cnt,List<RoomWrapper> Wrapperlst,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        Wrapperlst.sort();
        
        System.debug('Rooms for site '+Wrapperlst.size());
        // loop over the rooms to find the room that has capacity >= FRM12Cnt
        for(RoomWrapper rw:Wrapperlst) 
        {   
            System.debug('Room Capacity :'+rw.room.Capacity__c+' FRM1 Attempts: '+FRM1Cnt);
            if(rw.room.Capacity__c > 0 && rw.room.Capacity__c >= (FRM1Cnt - capacityAssigned))
            {
                
                // get all the exam attempts records and upate them with room Id
                System.debug('members for site :'+map_FRMSiteMembers.get(siteId).size());
                for(Id memId:map_FRMSiteMembers.get(siteId)) 
                {   System.debug('member Id :'+memId);
                    if(map_SiteExamAttempts.containsKey(memId))
                    {   System.debug('Exam Attempts '+map_SiteExamAttempts.get(memId).size());
                        for(Exam_Attempt__c exAtt:map_SiteExamAttempts.get(memId))
                        {
                            if(exAtt.Room__c==null) {
                                exAtt.Room__c = rw.room.Id;
                                ExAttUpdate.add(exAtt);
                                capacityAssigned++;
                            }
                        }
                    }
                }
            }
        }
        return capacityAssigned;        
    }
    
    
    private Decimal assignMultipleRoomsFRM1OR2(String siteId,Decimal FRM1Cnt,RoomWrapper roomWrapper,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        if(capacityAssigned != FRM1Cnt)
        {
            RoomWrapper rw = roomWrapper;
            System.debug('Room '+rw.room.Name+' Capacity'+rw.room.Capacity__c);
            // get the members
            if(rw.room.Capacity__c>0)
            {
                for(Id memId:map_FRMSiteMembers.get(siteId)) 
                {   System.debug('memId**'+memId);
                    if(map_SiteExamAttempts.containsKey(memId) && rw.room.Capacity__c>0)
                    {
                        for(Exam_Attempt__c exAtt:map_SiteExamAttempts.get(memId))
                        {
                            if(exAtt.Room__c==null && rw.room.Capacity__c>0) {
                                exAtt.Room__c = rw.room.Id;
                                ExAttUpdate.add(exAtt);
                                capacityAssigned++;
                            }
                        }
                        map_SiteExamAttempts.remove(memId);
                    }
                }
            }
                                                
        }       
        return capacityAssigned;
    }   
        
            
}