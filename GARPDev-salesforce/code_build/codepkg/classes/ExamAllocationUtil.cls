public class ExamAllocationUtil
{
    
    public static Decimal assignOneRoom(String siteId,Decimal ERPCnt,List<RoomWrapper> Wrapperlst,Map<String,List<Exam_Attempt__c>> mapSiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        Wrapperlst.sort();
        for(RoomWrapper rw:Wrapperlst) 
        {   System.debug('Capacity :'+rw.room.Capacity__c+' ERP Attempts: '+ERPCnt);
            if(rw.room.Capacity__c >= (ERPCnt - capacityAssigned))
            {
                System.debug('Exam Attempts :'+mapSiteExamAttempts.get(siteId).size());
                if(mapSiteExamAttempts.containsKey(siteId)){
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
        } 
        return capacityAssigned;        
    }
    
    public static Decimal assignMultipleRooms(String siteId,Decimal ERPCnt,RoomWrapper roomWrapper,Map<String,List<Exam_Attempt__c>> mapSiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
            RoomWrapper rw = roomWrapper;
            
            if(capacityAssigned != ERPCnt && rw.room.Capacity__c>0 && mapSiteExamAttempts.containsKey(siteId)){
                
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
                                                   
                
            }
            return capacityAssigned;
               
    }   

    public static Decimal assignOneRoomFRM12(String siteId,Decimal FRM12Cnt,List<RoomWrapper> Wrapperlst,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_FRM12SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        Wrapperlst.sort();
        
        // System.debug('Rooms for site '+Wrapperlst.size());
        // loop over the rooms to find the room that has capacity >= FRM12Cnt
        for(RoomWrapper rw:Wrapperlst) 
        {   System.debug('Room Id '+rw.room.Id+' Room Capacity :'+rw.room.Capacity__c+' FRM12 Attempts: '+FRM12Cnt+' capacityAssigned '+capacityAssigned);
            if(rw.room.Capacity__c > 0 && (FRM12Cnt - capacityAssigned)>0 && map_FRMSiteMembers.containsKey(siteId))
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
    
    
    public static Decimal assignMultipleRoomsFRM12(String siteId,Decimal FRM12Cnt,RoomWrapper roomWrapper,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_FRM12SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        // now start form the bootom of the Wrapperlst and assign rooms to the exam attempts
        Decimal count = 0;
        //System.debug('Wrapperlst.size(): '+(Wrapperlst.size()-1));
        RoomWrapper rw = roomWrapper;
        if(capacityAssigned != FRM12Cnt && rw.room.Capacity__c>0 && map_FRMSiteMembers.containsKey(siteId)){
                
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

    public static Decimal assignOneRoomFRM1OR2(String siteId,Decimal FRM1Cnt,List<RoomWrapper> Wrapperlst,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        Wrapperlst.sort();
        
        System.debug('Rooms for site '+Wrapperlst.size());
        // loop over the rooms to find the room that has capacity >= FRM12Cnt
        for(RoomWrapper rw:Wrapperlst) 
        {   
            System.debug('Room Capacity :'+rw.room.Capacity__c+' FRM1 Attempts: '+FRM1Cnt);
            if((FRM1Cnt - capacityAssigned)>0 && rw.room.Capacity__c >= (FRM1Cnt - capacityAssigned) && map_FRMSiteMembers.containsKey(siteId))
            {
                // get all the exam attempts records and upate them with room Id
                System.debug('members for site :'+map_FRMSiteMembers.get(siteId).size());
                for(Id memId:map_FRMSiteMembers.get(siteId)) 
                {   System.debug('member Id :'+memId+' map_SiteExamAttempts.containsKey(memId) :'+map_SiteExamAttempts.containsKey(memId));
                    if(map_SiteExamAttempts.containsKey(memId))
                    {   System.debug('Exam Attempts '+map_SiteExamAttempts.get(memId).size());
                        for(Exam_Attempt__c exAtt:map_SiteExamAttempts.get(memId))
                        {
                            if(exAtt.Room__c==null && rw.room.Capacity__c>0) {System.debug(exAtt.Id);System.debug(rw.room.Id);
                                exAtt.Room__c = rw.room.Id;
                                ExAttUpdate.add(exAtt);
                                capacityAssigned++;
                                rw.room.Capacity__c = rw.room.Capacity__c -1;
                            }
                        }
                    }
                }
            }
        }
        return capacityAssigned;        
    }
    
    
    public static Decimal assignMultipleRoomsFRM1OR2(String siteId,Decimal FRM1Cnt,RoomWrapper roomWrapper,Map<Id,Set<Id>> map_FRMSiteMembers,Map<String,List<Exam_Attempt__c>> map_SiteExamAttempts,List<Exam_Attempt__c> ExAttUpdate,Decimal capacityAssigned)
    {
        if(capacityAssigned != FRM1Cnt)
        {
            RoomWrapper rw = roomWrapper;
            System.debug('Room '+rw.room.Name+': Capacity :'+rw.room.Capacity__c);
            // get the members
            if(rw.room.Capacity__c>0 && map_FRMSiteMembers.containsKey(siteId))
            {
                for(Id memId:map_FRMSiteMembers.get(siteId)) 
                {   System.debug('memId**'+memId+' map_SiteExamAttempts.containsKey(memId) '+map_SiteExamAttempts.containsKey(memId));
                    if(map_SiteExamAttempts.containsKey(memId) && rw.room.Capacity__c>0)
                    {
                        for(Exam_Attempt__c exAtt:map_SiteExamAttempts.get(memId))
                        {
                            if(exAtt.Room__c==null && rw.room.Capacity__c>0) {System.debug(exAtt.Id);
                                exAtt.Room__c = rw.room.Id;
                                ExAttUpdate.add(exAtt);
                                capacityAssigned++;
                                rw.room.Capacity__c = rw.room.Capacity__c -1;
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