public class testVivek 
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
                String s = ea.Exam_Site__r.Site__c+ea.Section__c;
                List<Exam_Attempt__c> lst = map_ERPSiteExamAttempts.containsKey(s)?map_ERPSiteExamAttempts.get(s):new List<Exam_Attempt__c>();
                lst.add(ea);
                map_ERPSiteExamAttempts.put(s,lst);
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
          else
            {
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

        for(Id siteId :map_FRM12SiteExamAttempts.keySet())
        {
            System.debug('Member Id '+siteId);
            System.debug('Exam Attempts '+map_FRM12SiteExamAttempts.get(siteId).size());
        }
        for(Id siteId:map_FRM12SiteMembers.keySet())
        {
            System.debug('Site Id '+siteId);
            System.debug('Members '+map_FRM12SiteMembers.get(siteId));          
        }       

        List<Exam_Attempt__c> lst2Update = new List<Exam_Attempt__c>();
            //get list of sites for the exam
             
        for(Site__c site :lst_Sites)
            {   
            System.debug('Site Id :'+site.Id);
            List<Room__c> lst_room = map_siteRooms.containsKey(site.Id)?map_siteRooms.get(site.Id):new List<Room__c>();
            List<RoomWrapper> lst_Wrapper = new List<RoomWrapper>();
            if(lst_Room.size()>0){
                    
        for(Room__c rm:lst_room)
                        
            lst_Wrapper.add(new RoomWrapper(rm));
            lst_Wrapper.sort(); 
       }                   
                
        // get all the rooms for the site
                                
       if(site.No_of_Members_Enrolled_for_ERP__c!=null && lst_room.size()>0)
                
         {
            // for the site get the ERP numbers
           Decimal noOfERPAttempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_ERP__c);
                        
         if(noOfERPAttempts>0) // if ERP attempts are gretaer than 0, then continue assiging the rooms
           {
                            boolean isRoomAvailableWithCapacity = false;
                            String examType = map_exam2Type.get('a0ye0000000cFAB');
                            // loop over the rooms to find the room that has capacity >= noOfERPAttempts
                            for(RoomWrapper rw:lst_Wrapper) 
                            {   System.debug('Capacity :'+rw.room.Capacity__c+' ERP Attempts: '+noOfERPAttempts);
                                if(rw.room.Capacity__c >= noOfERPAttempts)
                                {
                                    isRoomAvailableWithCapacity = true;
                                    System.debug('ERP :'+site.Id+examType);
                                    // get all the exam attempts records and upate them with room Id
                                    for(Exam_Attempt__c exAtt:map_ERPSiteExamAttempts.get(site.Id+examType))
                                    {
                                        if(exAtt.Room__c==null) {
                                            exAtt.Room__c = rw.room.Id;
                                            lst2Update.add(exAtt);
                                            rw.room.Capacity__c = rw.room.Capacity__c -1;
                                    }}}}
         if(!isRoomAvailableWithCapacity)// no room available with the capacity of registered members
                            {
                                // now start form the bootom of the lst_Wrapper and assign rooms to the exam attempts
                                Decimal count = 0;
                                System.debug('lst_Wrapper.size(): '+(lst_Wrapper.size()-1));
                                Integer i = lst_Wrapper.size()-1;
                                for(RoomWrapper rmw : lst_Wrapper)
                                {
                                    if(count != noOfERPAttempts){
                                        RoomWrapper rw = lst_Wrapper[i];
                                        System.debug('Exam Attempts :'+map_ERPSiteExamAttempts.get(site.Id));
                                        for(Exam_Attempt__c exAtt:map_ERPSiteExamAttempts.get(site.Id+examType))
                                        {
                                            if(exAtt.Room__c==null && rw.room.Capacity__c>0) {
                                                exAtt.Room__c = rw.room.Id;
                                                lst2Update.add(exAtt);
                                                rw.room.Capacity__c = rw.room.Capacity__c -1;
                                                count++;
                                            }} 
                                        i--;                                    
                                      }}}}}
         // if frm 1&2 attempts are gretaer than 0, then continue assiging the rooms
                                    
          if(site.No_of_Members_Enrolled_for_FRM1_2__c!=null && lst_room.size()>0)
                {
                    Decimal noOfFRM12Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM1_2__c);
                    if(noOfFRM12Attempts>0)
                    {
                        lst_Wrapper.sort();
                        boolean isRoomAvailableWithCapacity = false;
                        System.debug('Rooms for site '+lst_Wrapper.size());
                        // loop over the rooms to find the room that has capacity >= noOfFRM12Attempts
                        for(RoomWrapper rw:lst_Wrapper) 
                        {   System.debug('Room Capacity :'+rw.room.Capacity__c+' FRM12 Attempts: '+noOfFRM12Attempts);
                            if(rw.room.Capacity__c > 0 && rw.room.Capacity__c >= noOfFRM12Attempts)
                            {
                                isRoomAvailableWithCapacity = true;
                                // get all the exam attempts records and upate them with room Id
                                System.debug('members for site :'+map_FRMSiteMembers.get(site.Id).size());
                                for(Id memId:map_FRMSiteMembers.get(site.Id)) 
                                {   System.debug('member Id :'+memId);
                                    if(map_FRM12SiteExamAttempts.containsKey(memId))
                                    {   System.debug('Exam Attempts '+map_FRM12SiteExamAttempts.get(memId).size());
                                        for(Exam_Attempt__c exAtt:map_FRM12SiteExamAttempts.get(memId))
                                        {
                                            if(exAtt.Room__c==null) {
                                                exAtt.Room__c = rw.room.Id;
                                                lst2Update.add(exAtt);
                                      }}
                                    rw.room.Capacity__c = rw.room.Capacity__c -1; 
                                    }}}}
           if(!isRoomAvailableWithCapacity)
                        {
                            // now start form the bootom of the lst_Wrapper and assign rooms to the exam attempts
                            Decimal count = 0;
                            System.debug('lst_Wrapper.size(): '+(lst_Wrapper.size()-1));
                            Integer i = lst_Wrapper.size()-1;
                            for(RoomWrapper rmw : lst_Wrapper)
                            {   
                                if(count != noOfFRM12Attempts){
                                    RoomWrapper rw = lst_Wrapper[i];
                                    System.debug('Room '+rw.room.Name+' Capacity'+rw.room.Capacity__c);
                                    // get the members
                                    if(rw.room.Capacity__c>0)
                                    {
                                        for(Id memId:map_FRMSiteMembers.get(site.Id)) 
                                        {   System.debug('memId**'+memId);
                                            if(map_FRM12SiteExamAttempts.containsKey(memId) && rw.room.Capacity__c>0)
                                            {
                                                for(Exam_Attempt__c exAtt:map_FRM12SiteExamAttempts.get(memId))
                                                {
                                                    if(exAtt.Room__c==null && rw.room.Capacity__c>0) {
                                                        exAtt.Room__c = rw.room.Id;
                                                        lst2Update.add(exAtt);
                                                 }}
                                                rw.room.Capacity__c = rw.room.Capacity__c -1;
                                                count++;
                                                map_FRM12SiteExamAttempts.remove(memId);
                                            }}}
                                            i--;                                    
                                    }}}}}
               // if frm 1 attempts are gretaer than 0, then continue assigning the rooms.
               
        if(site.No_of_Members_Enrolled_for_FRM1_Only__c!=null && lst_room.size()>0)
                {
                        lst_Wrapper.sort();
                        Decimal noOfFRM1Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM1_Only__c);
                        if(noOfFRM1Attempts>0) // if ERP attempts are gretaer than 0, then continue assiging the rooms
                        {
                         boolean isRoomAvailableWithCapacity = false;
                           
                        for(RoomWrapper rw:lst_Wrapper) 
                        {   
                        System.debug('Room Capacity :'+rw.room.Capacity__c+' FRM1 Attempts: '+noOfFRM1Attempts);
                            if(rw.room.Capacity__c > 0 && rw.room.Capacity__c >= noOfFRM1Attempts)
                            {
                                isRoomAvailableWithCapacity = true;
                                // get all the exam attempts records and upate them with room Id
                                System.debug('members for site :'+map_FRMSiteMembers.get(site.Id).size());
                                for(Id memId:map_FRMSiteMembers.get(site.Id)) 
                                {   System.debug('member Id :'+memId);
                                    if(map_FRM1SiteExamAttempts.containsKey(memId))
                                    {   System.debug('Exam Attempts '+map_FRM1SiteExamAttempts.get(memId).size());
                                        for(Exam_Attempt__c exAtt:map_FRM1SiteExamAttempts.get(memId))
                                        {
                                            if(exAtt.Room__c==null) {
                                                exAtt.Room__c = rw.room.Id;
                                                lst2Update.add(exAtt);
                                            }}}}}}
        if(!isRoomAvailableWithCapacity)
                            {
                                // now start form the bootom of the lst_Wrapper and assign rooms to the exam attempts
                                Decimal count = 0;
                                System.debug('lst_Wrapper.size(): '+(lst_Wrapper.size()-1));
                                Integer i = lst_Wrapper.size()-1;
                            for(RoomWrapper rmw : lst_Wrapper)
                            {   
                                if(count != noOfFRM1Attempts){
                                    RoomWrapper rw = lst_Wrapper[i];
                                    System.debug('Room '+rw.room.Name+' Capacity'+rw.room.Capacity__c);
                                    // get the members
                                    if(rw.room.Capacity__c>0)
                                    {
                                        for(Id memId:map_FRMSiteMembers.get(site.Id)) 
                                        {   System.debug('memId**'+memId);
                                            if(map_FRM1SiteExamAttempts.containsKey(memId) && rw.room.Capacity__c>0)
                                            {
                                                for(Exam_Attempt__c exAtt:map_FRM1SiteExamAttempts.get(memId))
                                                {
                                                    if(exAtt.Room__c==null && rw.room.Capacity__c>0) {
                                                        exAtt.Room__c = rw.room.Id;
                                                        lst2Update.add(exAtt);
                                                        }
                                                }
                                                count++;
                                                map_FRM1SiteExamAttempts.remove(memId);
                                            }}}
                                    i--;                                    
                                    }}}}}
       
       // if frm 1 attempts are gretaer than 0, then continue assigning the rooms.
                                 
             if(site.No_of_Members_Enrolled_for_FRM_2_Only__c!=null && lst_room.size()>0)
                {
                        lst_Wrapper.sort();
                        // for the site get the ERP numbers
                        Decimal noOfFRM2Attempts = Decimal.valueOf(site.No_of_Members_Enrolled_for_FRM_2_Only__c);
                        if(noOfFRM2Attempts>0) // if ERP attempts are gretaer than 0, then continue assiging the rooms
                        {
                            boolean isRoomAvailableWithCapacity = false;
                        // loop over the rooms to find the room that has capacity >= noOfFRM1Attempts
                        for(RoomWrapper rw:lst_Wrapper) 
                        
                        {   System.debug('Room Capacity :'+rw.room.Capacity__c+' FRM2 Attempts: '+noOfFRM2Attempts);
                            if(rw.room.Capacity__c > 0 && rw.room.Capacity__c >= noOfFRM2Attempts)
                            {
                                isRoomAvailableWithCapacity = true;
                                // get all the exam attempts records and upate them with room Id
                                System.debug('members for site :'+map_FRMSiteMembers.get(site.Id).size());
                                for(Id memId:map_FRMSiteMembers.get(site.Id)) 
                                {   System.debug('member Id :'+memId);
                                    if(map_FRM2SiteExamAttempts.containsKey(memId))
                                    {   System.debug('Exam Attempts '+map_FRM2SiteExamAttempts.get(memId).size());
                                        for(Exam_Attempt__c exAtt:map_FRM2SiteExamAttempts.get(memId))
                                        {
                                            if(exAtt.Room__c==null) {
                                                exAtt.Room__c = rw.room.Id;
                                                lst2Update.add(exAtt);
                                            }}}}}}
              if(!isRoomAvailableWithCapacity)
                            {
                                // now start form the bootom of the lst_Wrapper and assign rooms to the exam attempts
                                Decimal count = 0;
                                System.debug('lst_Wrapper.size(): '+(lst_Wrapper.size()-1));
                                Integer i = lst_Wrapper.size()-1;
                            for(RoomWrapper rmw : lst_Wrapper)
                            {   
                                if(count != noOfFRM2Attempts){
                                    RoomWrapper rw = lst_Wrapper[i];
                                    System.debug('Room '+rw.room.Name+' Capacity'+rw.room.Capacity__c);
                                    // get the members
                                    if(rw.room.Capacity__c>0)
                                    {
                                        for(Id memId:map_FRMSiteMembers.get(site.Id)) 
                                        {   System.debug('memId**'+memId);
                                            if(map_FRM2SiteExamAttempts.containsKey(memId) && rw.room.Capacity__c>0)
                                            {
                                                for(Exam_Attempt__c exAtt:map_FRM2SiteExamAttempts.get(memId))
                                                {
                                                    if(exAtt.Room__c==null && rw.room.Capacity__c>0) {
                                                        exAtt.Room__c = rw.room.Id;
                                                        lst2Update.add(exAtt);
                                                }}
                                                count++;
                                                map_FRM2SiteExamAttempts.remove(memId);
                                            }}}
                            i--;                                    
                                 }}}}}}
            if(lst2Update.size()>0)
            update lst2Update;
    }}