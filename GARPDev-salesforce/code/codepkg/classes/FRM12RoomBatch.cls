global class FRM12RoomBatch implements Database.Batchable<sObject>, Database.Stateful{
    global String errorMsgs = '';
    global String query;
    global Exam_Group__c examGroup;
    global List<ExamSiteids__c> examSiteIds = ExamSiteids__c.getall().values();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
         List<Exam_Date__c > lstDate = Exam_Date__c.getAll().values();
         String datExam = lstDate[0].Date_String__c;
         String strSection = lstDate[0].Name;
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
               query1 += ' AND Other_Exam_Registrations__c != NULL';
               query1 += ' AND Exam_Date__c ='+ datExam; 
               query1 += ' AND Opportunity_StageName__c =\''+oppstatus+'\'';                 
               query1 += ' AND  Cancelled__c != true'; 
               query1 += ' AND Defered__c !=\''+StrDefered+'\'';  
               query1 += ' AND  ADA_Status__c != \''+RADADA+'\''; 
               query1 += ' AND  RAD_Status__c != \''+RADADA+'\''; 
               query1 += ' AND  Exam_Site__r.Site__c in: setSiteIds'; 
               
         if(test.isRunningTest()){
             query1 = 'SELECT Id,Exam_Site__c,Exam_Site__r.Site__c,Other_Exam_Registrations__c FROM Exam_Attempt__c Where Section__c =\''+strSection+'\'';
               query1 += ' AND Other_Exam_Registrations__c != NULL';
               query1 += ' AND Exam_Date__c ='+ datExam; 
               query1 += ' AND Defered__c !=\''+StrDefered+'\'';                 
               query1 += ' AND  Cancelled__c != true';
               query1 += ' AND  Candidate_Commitment__r.status !=\''+status+'\''; 
              // query1 += ' AND  Exam_Site__c =\''+strexsiteid+'\'';
              query1+= ' limit 10';
         }      
              
    

        system.debug('---query--'+query1);
        return Database.getQueryLocator(query1);   
    }
   
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope)
    {
        Map<String,List<Id>> mapsiteidexid = new Map<String,List<Id>>();
        List<String> lstsiteids = new List<String>();
        Map<String,List<Venue__c>> mapvenuids = new Map<String,List<Venue__c>>();
        List<Id> lstVenueids = new List<Id>();
        Map<String,List<Room__c>> maproomids = new Map<String,List<Room__c>>();
        List<String> lstOtherExamids = new List<String>();
        Map<String,Exam_Attempt__c> mapOtherExamids = new Map<String,Exam_Attempt__c>();
                 
        
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
            
            if(mapOtherExamids == null || (mapOtherExamids != null && mapOtherExamids.get(objEx.Other_Exam_Registrations__c) == null))
            {
                mapOtherExamids.put(objEx.Other_Exam_Registrations__c,objEx);
                lstOtherExamids.add(objEx.Other_Exam_Registrations__c);
                
            }          
        }
        system.debug('------mapsiteidexid----'+mapsiteidexid);
        system.debug('------lstsiteids----'+lstsiteids);
        system.debug('------mapOtherExamids----'+mapOtherExamids);
        system.debug('------lstOtherExamids----'+lstOtherExamids);
        
        Map<Id,Exam_Attempt__c> mapotherExAttempt = new Map<Id,Exam_Attempt__c>([SELECT Id FROM Exam_Attempt__c WHERE Id IN: lstOtherExamids]);
               
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
        List<Room__c> lstRoom = [SELECT Id,Name,Active__c,Capacity__c,Priority__c,Latest_Seat_No__c,No_of_seats_assigned_for_FRM_1_2__c,Number_of_seats_remaining_capacity__c,Venue__c FROM Room__c WHERE Active__c = true AND Venue__c IN: lstVenueids Order by Priority__c ASC];
        
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
                                Integer FRM12SeatsAllocated = Integer.valueOf(objfinalroom.No_of_seats_assigned_for_FRM_1_2__c == null ? 0 : objfinalroom.No_of_seats_assigned_for_FRM_1_2__c);
                                Integer FRM12SeatsRemaining = Integer.valueOf(objfinalroom.Number_of_seats_remaining_capacity__c == null ? 0 : objfinalroom.Number_of_seats_remaining_capacity__c);
                                Integer FRM12latestseatnumber = Integer.valueOf(objfinalroom.Latest_Seat_No__c == null ? 0 : objfinalroom.Latest_Seat_No__c);
                                
                                system.debug('------capcity ----'+capcity );
                                system.debug('------FRM12SeatsAllocated ----'+FRM12SeatsAllocated );
                                system.debug('------FRM12SeatsRemaining ----'+FRM12SeatsRemaining );
                                
                                if(FRM12SeatsRemaining > 0 && FRM12SeatsRemaining <= capcity)
                                 {
                                     objfinalex.Room__c = objfinalroom.Id;
                                     //objfinalex.Other_Exam_Registrations__r.Room__c=objfinalroom.Id;
                                     Integer iSeatNo = FRM12latestseatnumber + 1;
                                     Integer iSeatNoFRM12 = FRM12SeatsAllocated + 1;
                                     objfinalex.Seat_No__c = String.valueOf(iSeatNo);
                                     //objfinalex.Other_Exam_Registrations__r.Seat_No__c = objfinalroom.Id;
                                     objfinalroom.No_of_seats_assigned_for_FRM_1_2__c = iSeatNoFRM12;
                                     
                                     lstEa.add(objfinalex);
                                     
                                     if(mapotherExAttempt != null && mapotherExAttempt.get(objfinalex.Other_Exam_Registrations__c) != null)
                                     {
                                         Exam_Attempt__c recOtherExAttempt = mapotherExAttempt.get(objfinalex.Other_Exam_Registrations__c);
                                         recOtherExAttempt.Room__c=objfinalroom.Id;
                                         recOtherExAttempt.Seat_No__c = objfinalex.Seat_No__c;
                                         lstEa.add(recOtherExAttempt);
                                     }
                                     
                                    // lstRoomData.add(objfinalroom);
                                    if(mapRoomData == null || (mapRoomData != null && mapRoomData.get(objfinalroom.Id) == null ))
                                     {
                                         mapRoomData.put(objfinalroom.Id,objfinalroom);
                                     }
                                     else
                                     {
                                         if(mapRoomData != null && mapRoomData .get(objfinalroom.Id) != null)
                                         {
                                             Room__c recroomdata= mapRoomData .get(objfinalroom.Id);
                                             if(objfinalroom.No_of_seats_assigned_for_FRM_1_2__c > recroomdata.No_of_seats_assigned_for_FRM_1_2__c)
                                             {
                                                 recroomdata.No_of_seats_assigned_for_FRM_1_2__c = objfinalroom.No_of_seats_assigned_for_FRM_1_2__c;
                                             }
                                             mapRoomData.put(objfinalroom.Id,recroomdata);
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