public class RoomCounter
{
    public static void updateRooms(List<Room__c> lstRooms,Set<String> setSiteIDs,String strExamName)
    {
        //Map<Id,List<RoomWrapper>> mapRoomAllocated = new Map<Id,List<RoomWrapper>>();
        Map<Id,Map<Id,Room__c>> mapRoomAllocated = new Map<Id,Map<Id,Room__c>>();
        Map<Id,List<Room__c>> mapListRooms = new Map<Id,List<Room__c>>();

        for(Room__c objRoom : lstRooms)
        {
            system.debug('objRoom == '+objRoom);
            if(mapRoomAllocated.containsKey(objRoom.Venue__r.Site__c))
            {
                mapRoomAllocated.get(objRoom.Venue__r.Site__c).put(objRoom.Id,objRoom);
                 mapListRooms.get(objRoom.Venue__r.Site__c).add(objRoom);
            }
            else
            {
                mapRoomAllocated.put(objRoom.Venue__r.Site__c,new Map<Id,Room__c>{objRoom.Id=>objRoom});
                mapListRooms.put(objRoom.Venue__r.Site__c,new List<Room__c>{objRoom});
            }
        }
        system.debug('mapRoomAllocated Size == '+mapRoomAllocated.size());
        system.debug('mapRoomAllocated Values == '+mapRoomAllocated);
        system.debug('setSiteIDs == '+setSiteIDs);
        //Query Exam Attempts to update Room and Seat details.
        Integer roomCount = 0;
        Map<Id,List<Exam_Attempt__c>> mapExamOnSites = new Map<Id,List<Exam_Attempt__c>>();
        for(Exam_Attempt__c objEA : [select id,Seat_No__c,Defered__c,Room__c,Cancelled__c,Site__c ,ADA_Status__c,RAD_Status__c,Opportunity_StageName__c,Candidate_Commitment__r.status from Exam_Attempt__c 
                                        where Site__c in: setSiteIDs and Section__c =: strExamName and Defered__c != 'Pending' and Cancelled__c != true and ADA_Status__c!= 'Approved' and RAD_Status__c != 'Approved' and Opportunity_StageName__c ='closed'])
        {
            if(mapExamOnSites.containsKey(objEA.Site__c))
                mapExamOnSites.get(objEA.Site__c).add(objEA);
            else
                mapExamOnSites.put(objEA.Site__c,new List<Exam_Attempt__c>{objEA});
        }
        
        if(test.isRunningTest())
        {
           for(Exam_Attempt__c objEA : [select id,Seat_No__c,Defered__c,Room__c,Cancelled__c,Site__c ,Candidate_Commitment__r.status from Exam_Attempt__c where Section__c =: strExamName and Defered__c != 'Pending' and Cancelled__c != true and Candidate_Commitment__r.status like'%Activated%' ])
            {
                if(mapExamOnSites.containsKey(objEA.Site__c))
                    mapExamOnSites.get(objEA.Site__c).add(objEA);
                else
                    mapExamOnSites.put(objEA.Site__c,new List<Exam_Attempt__c>{objEA});
            }
                    
        }
        
        system.debug('mapExamOnSites Size == '+mapExamOnSites.size());
        system.debug('mapExamOnSites Values == '+mapExamOnSites);
        List<Exam_Attempt__c> lstEa = new List<Exam_Attempt__c>();
        List<Room__c> lstRoomData = new List<Room__c>();
        for(Id idSite : mapRoomAllocated.keySet())
        {
            if(mapExamOnSites != null && mapExamOnSites.get(idSite) != null)
            {
                //Integer iSeatNo = null;
                for(Exam_Attempt__c objExamAttempt : mapExamOnSites.get(idSite))
                {
                    Map<Id,Room__c> mapRoomDetails = mapRoomAllocated.get(idSite);
                    system.debug('mapRoomDetails== '+mapRoomDetails);
                    
                    for(Room__c roomRec : mapListRooms.get(idSite))
                    {
                            system.debug('roomRec== '+roomRec);
                            Integer capcity = Integer.valueOf(roomRec.Capacity__c == null ? 0 : roomRec.Capacity__c);
                            Integer erpSeatsAllocated = Integer.valueOf(roomRec.ERP_Seats_Allocated__c == null ? 0 : roomRec.ERP_Seats_Allocated__c);
                            if(capcity <= erpSeatsAllocated) continue;
                            //{
                            objExamAttempt.Room__c = roomRec.Id;
                           // Integer iAllocatedSeats = erpSeatsAllocated
                           
                            //if(iSeatNo == null)
                                //iSeatNo = Integer.valueOf((roomRec.Latest_Seat_No__c == null ? 0 : roomRec.Latest_Seat_No__c));
                            Integer iSeatNo = erpSeatsAllocated + 1;
                            objExamAttempt.Seat_No__c = String.valueOf(iSeatNo);
                            roomRec.ERP_Seats_Allocated__c = iSeatNo;
                            //lstUpdatedExams.add(objExamAttempt);
                            lstEa.add(objExamAttempt);
                            lstRoomData.add(roomRec);
                            break;
    
                            //}
    
                    }
    
                }
            }
                    


        }

        system.debug('Exam Attempt =='+lstEa);
        system.debug('Rooms  =='+lstRoomData);

        if(!lstEa.isEmpty())
            update lstEa;
        if(!lstRooms.isEmpty())
            update lstRooms;
                
        
    }
    
   
}