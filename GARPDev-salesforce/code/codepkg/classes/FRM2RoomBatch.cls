global class FRM2RoomBatch implements Database.Batchable<SObject>,Database.Stateful
{
     global List<ExamSiteids__c> examSiteIds = ExamSiteids__c.getall().values();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
         List<Exam_Date__c > lstDate = Exam_Date__c.getAll().values();
         String strSection = 'FRM Part 2';
         String datExam = lstDate[0].Date_String__c;
         String StrDefered = 'Pending';
         String RADADA = 'Approved';
         String oppstatus = 'closed';
         String status = 'draft';
         Set<String> setSiteIds = new Set<String>();
          for(ExamSiteids__c examSite : examSiteIds)
          {
            setSiteIds.add(examSite.Name);
          }
    
         
        String query1 = 'SELECT Id,Exam_Site__c,Exam_Site__r.Site__c,ADA_Status__c,RAD_Status__c,Opportunity_StageName__c ,Other_Exam_Registrations__c FROM Exam_Attempt__c Where Section__c =\''+strSection+'\'';
               query1 += ' AND Other_Exam_Registrations__c = NULL';
               query1 += ' AND Exam_Date__c ='+ datExam; 
               query1 += ' AND Opportunity_StageName__c =\''+oppstatus+'\'';                 
               query1 += ' AND  Cancelled__c != true'; 
               query1 += ' AND Defered__c !=\''+StrDefered+'\'';  
               query1 += ' AND  ADA_Status__c != \''+RADADA+'\''; 
               query1 += ' AND  RAD_Status__c != \''+RADADA+'\''; 
               query1 += ' AND  Exam_Site__r.Site__c in: setSiteIds'; 
               
         if(test.isRunningTest()){
             query1 = 'SELECT Id,Exam_Site__c,Exam_Site__r.Site__c,Other_Exam_Registrations__c FROM Exam_Attempt__c Where Section__c =\''+strSection+'\'';
               query1 += ' AND Other_Exam_Registrations__c = NULL';
               query1 += ' AND Exam_Date__c ='+ datExam; 
               query1 += ' AND Defered__c !=\''+StrDefered+'\'';                 
               query1 += ' AND  Cancelled__c != true';
               query1 += ' AND  Candidate_Commitment__r.status !=\''+status+'\''; 
              // query1 += ' AND  Exam_Site__c =\''+strexsiteid+'\'';
              query1+= ' limit 10';
         }      
       
         return Database.getQueryLocator(query1);
     } 
     
     global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope)
     {
         
        Map<String,List<Id>> mapsiteidexid = new Map<String,List<Id>>();
        List<String> lstsiteids = new List<String>();
        Map<String,List<Venue__c>> mapvenuids = new Map<String,List<Venue__c>>();
        List<Id> lstVenueids = new List<Id>();
        Map<String,List<Room__c>> maproomids = new Map<String,List<Room__c>>();
                   
        
        for(Exam_Attempt__c objEx : scope)
        {
            if(mapsiteidexid == null || (mapsiteidexid != null && mapsiteidexid.get(objEx.Exam_Site__r.Site__c) == null))
            {
                List<Id> recId = new List<Id>();
                recId.add(objEx.Id);
                mapsiteidexid.put(objEx.Exam_Site__r.Site__c,recId);
                lstsiteids.add(objEx.Exam_Site__r.Site__c);                
            }
            else
            {
                if(mapsiteidexid != null && mapsiteidexid.get(objEx.Exam_Site__r.Site__c) != null)
                {
                    List<Id> lstids = mapsiteidexid.get(objEx.Exam_Site__r.Site__c);
                    lstids.add(objEx.Id);
                    mapsiteidexid.put(objEx.Exam_Site__r.Site__c,lstids);
                }
            }  
                   
        }
        system.debug('------mapsiteidexid----'+mapsiteidexid);
        system.debug('------lstsiteids----'+lstsiteids);
      
        List<Venue__c> lstVenue = [SELECT Id,No_of_Rooms_Active__c,Site__c FROM Venue__c WHERE Site__c IN: lstsiteids];
        
        for(Venue__c objVenue : lstVenue)
        {
            if(mapvenuids == null ||(mapvenuids != null && mapvenuids.get(objVenue.Site__c) == null))
            {
                List<Venue__c> recvenue = new List<Venue__c>();
                recvenue.add(objVenue);
                mapvenuids.put(objVenue.Site__c,recvenue);
                lstVenueids.add(objVenue.Id);
                
            }
            else
            {
                if(mapvenuids != null && mapvenuids.get(objVenue.Site__c) != null)
                {
                    List<Venue__c> recVenue = mapvenuids.get(objVenue.Site__c);
                    recVenue.add(objVenue);
                    mapvenuids.put(objVenue.Site__c,recVenue);
                }
            }   
        }
        system.debug('------mapvenuids----'+mapvenuids);
        system.debug('------lstVenueids----'+lstVenueids);
        List<Room__c> lstRoom = [SELECT Id,Name,Active__c,Capacity__c, Last_seat_no_FRM2__c ,Priority__c,Latest_Seat_No__c,Number_of_seats_assigned_for_FRM_2__c,Number_of_seats_remaining_for_frm2__c,Venue__c FROM Room__c WHERE Active__c = true AND Venue__c IN: lstVenueids Order by Priority__c ASC];
        
        for(Room__c objRoom : lstRoom)
        {
            if(maproomids == null || (maproomids != null && maproomids.get(objRoom.Venue__c) == null))
            {
                List<Room__c> recRoom = new List<Room__c>();
                recRoom.add(objRoom);
                maproomids.put(objRoom.Venue__c,recRoom);
            }
            else
            {
                if(maproomids!= null && maproomids.get(objRoom.Venue__c) != null)
                {
                    List<Room__c> recRoom = maproomids.get(objRoom.Venue__c);
                    recRoom.add(objRoom);
                    maproomids.put(objRoom.Venue__c,recRoom);
                }
            }
        }
        
        system.debug('------maproomids----'+maproomids);
                
        List<Exam_Attempt__c> lstEa = new List<Exam_Attempt__c>();
        List<Room__c> lstRoomData = new List<Room__c>();
        Map<Id,Room__c> mapRoomData = new Map<Id,Room__c>();
        Map<Id,Integer> mapseatnumberforbulkupload = new Map<Id,Integer>();
        Map<Id,Integer> mapFRM2SeatsAllocatedforbulkupload = new Map<Id,Integer>();
        
        for(Exam_Attempt__c objfinalex : scope)
        {
            system.debug('------scope----'+scope);
            system.debug('------mapvenuids ----'+mapvenuids);
             system.debug('------mapvenuids.get(objfinalex.Exam_Site__r.Site__c) ----'+mapvenuids.get(objfinalex.Exam_Site__r.Site__c));
            if(mapvenuids != null && mapvenuids.get(objfinalex.Exam_Site__r.Site__c)!= null)
            {
                List<Venue__c> lstfinalvenue = mapvenuids.get(objfinalex.Exam_Site__r.Site__c);
                system.debug('------lstfinalvenue ----'+lstfinalvenue);
                if(lstfinalvenue!= null && lstfinalvenue.size() == 1)
                {
                    for(Venue__c objfinvenue : lstfinalvenue)
                    {
                        if(maproomids != null && maproomids.get(objfinvenue.Id) != null)
                        {
                            List<Room__c> lstfinalroom = maproomids.get(objfinvenue.Id);
                            system.debug('------lstfinalroom ----'+lstfinalroom );
                            for(Room__c objfinalroom : lstfinalroom)
                            {
                                system.debug('------objfinalroom----'+objfinalroom);
                                Integer capcity = Integer.valueOf(objfinalroom.Capacity__c == null ? 0 : objfinalroom.Capacity__c);
                                Integer FRM2SeatsAllocated = Integer.valueOf(objfinalroom.Number_of_seats_assigned_for_FRM_2__c == null ? 0 : objfinalroom.Number_of_seats_assigned_for_FRM_2__c);
                                Integer FRM2SeatsRemaining = Integer.valueOf(objfinalroom.Number_of_seats_remaining_for_frm2__c == null ? 0 : objfinalroom.Number_of_seats_remaining_for_frm2__c);
                                Integer FRM2latestseatnumber = Integer.valueOf(objfinalroom.Latest_Seat_No__c == null ? 0 : objfinalroom.Last_seat_no_FRM2__c);
                                
                                system.debug('------capcity ----'+capcity );
                                system.debug('------FRM2SeatsAllocated ----'+FRM2SeatsAllocated);
                                system.debug('------FRM2SeatsRemaining ----'+FRM2SeatsRemaining);
                                system.debug('------FRM2latestseatnumber ----'+FRM2latestseatnumber );
                                
                                if(FRM2SeatsRemaining > 0)//  && FRM2SeatsAllocated < FRM2SeatsRemaining && FRM2SeatsRemaining <= capcity)
                                 {
                                     Integer iSeatNo = FRM2latestseatnumber + 1;
                                     Integer iSeatNoFRM2 = FRM2SeatsAllocated + 1;
                                                                          
                                     If(mapseatnumberforbulkupload != null && mapseatnumberforbulkupload.get(objfinalroom.Id) != null)
                                     {
                                         iSeatNo = mapseatnumberforbulkupload.get(objfinalroom.Id) +1;
                                     }
                                     
                                     if(mapFRM2SeatsAllocatedforbulkupload  != null && mapFRM2SeatsAllocatedforbulkupload.get(objfinalroom.Id) != null)
                                     {
                                         iSeatNoFRM2 = mapFRM2SeatsAllocatedforbulkupload.get(objfinalroom.Id) + 1;
                                     }
                                     
                                     objfinalex.Room__c = objfinalroom.Id;
                                     objfinalex.Seat_No__c = String.valueOf(iSeatNo);
                                     objfinalroom.Number_of_seats_assigned_for_FRM_2__c = iSeatNoFRM2;
                                                                         
                                     system.debug('iSeatNo =='+iSeatNo);
                                     system.debug('iSeatNoFRM1 =='+iSeatNoFRM2);
                                    // system.debug('intseatcountforbulkupload =='+intseatcountforbulkupload);
                                     
                                     lstEa.add(objfinalex);
                                     
                                    // lstRoomData.add(objfinalroom);
                                    if(mapRoomData == null || (mapRoomData != null && mapRoomData.get(objfinalroom.Id) == null ))
                                     {
                                         mapRoomData.put(objfinalroom.Id,objfinalroom);
                                         mapseatnumberforbulkupload.put(objfinalroom.Id,Integer.valueOf(objfinalex.Seat_No__c));
                                         mapFRM2SeatsAllocatedforbulkupload.put(objfinalroom.Id,Integer.valueOf(objfinalroom.Number_of_seats_assigned_for_FRM_2__c)); 
                                     }
                                     else
                                     {
                                         if(mapRoomData != null && mapRoomData.get(objfinalroom.Id) != null)
                                         {
                                             Room__c recroomdata= mapRoomData .get(objfinalroom.Id);
                                             if(objfinalroom.Number_of_seats_assigned_for_FRM_2__c > recroomdata.Number_of_seats_assigned_for_FRM_2__c)
                                             {
                                                 recroomdata.Number_of_seats_assigned_for_FRM_2__c = objfinalroom.Number_of_seats_assigned_for_FRM_2__c;
                                             }
                                             
                                             mapRoomData.put(objfinalroom.Id,recroomdata);
                                             
                                             //Integer seatcountnumber = mapseatnumberforbulkupload.get(objfinalroom.Id);
                                             Integer seatcountnumber = Integer.valueOf(objfinalex.Seat_No__c);
                                             mapseatnumberforbulkupload.put(objfinalroom.Id,seatcountnumber);
                                             
                                             //Integer intFRM1seatsallocated = mapFRM2SeatsAllocatedforbulkupload.get(objfinalroom.Id);
                                             Integer intFRM1seatsallocated = Integer.valueOf(objfinalroom.Number_of_seats_assigned_for_FRM_2__c);
                                             mapFRM2SeatsAllocatedforbulkupload.put(objfinalroom.Id,intFRM1seatsallocated);
                                         }
                                     } 
                                    
                                       break; 
                                 }
                               
                            }
                        }
                                         
                    }
                    
                }
            }
        }
        
        if(mapRoomData != null)
        {
            for(Id Objroomdata : mapRoomData.keySet())
            {
                lstRoomData.add(mapRoomData.get(Objroomdata));
            }
        }
        system.debug('Exam Attempt =='+lstEa);
        system.debug('Rooms  =='+lstRoomData);
        system.debug('mapseatnumberforbulkupload =='+mapseatnumberforbulkupload);
        system.debug('mapRoomData =='+mapRoomData);

        if(!lstEa.isEmpty())
        {
           update lstEa;
        }
            
        if(!lstRoomData.isEmpty())
        {
           update lstRoomData;
        }
               
     }
     
     global void finish(Database.BatchableContext BC)
     {
         
     }
}