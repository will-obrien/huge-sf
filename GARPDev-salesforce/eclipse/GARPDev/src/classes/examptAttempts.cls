public class examptAttempts{

public void getExamAttempts(Set<String> setSiteIDs)
   {
        Map<Id,Map<Id,Map<String,Integer>>> mapExamAttemptsForSite = new Map<Id,Map<Id,Map<String,Integer>>>();
        Map<Id,Map<String,Integer>>  mapCountDetails = null;
        Map<Id,Integer> mapNoOfAttempts = new Map<Id,Integer>();
        Set<String> setFRM = new Set<String>{'FRM Part 1','FRM Part 2'};
        for(Exam_Attempt__c obj : [select id,Section__c,Site__c,Member__c,Exam_Site__c from Exam_Attempt__c where  Site__c in: setSiteIDs])
        {
             mapCountDetails = new Map<Id,Map<String,Integer>>();
             Integer totalcount = (mapNoOfAttempts.get(obj.Site__c) == null ? 0 : mapNoOfAttempts.get(obj.Site__c));
             mapNoOfAttempts.put(obj.Site__c,totalcount+1);
             
             system.debug('mapExamAttemptsForSite == '+mapExamAttemptsForSite);
             system.debug('obj.Site__c== '+obj.Site__c);
             system.debug('obj == '+obj);
            if(mapExamAttemptsForSite.containsKey(obj.Site__c))
            {
               system.debug('In First == '+mapExamAttemptsForSite);
               mapCountDetails = mapExamAttemptsForSite.get(obj.Site__c);
               system.debug('In First mapCountDetails == '+mapCountDetails);
               if(mapCountDetails.containsKey(obj.Member__c))
               {
                   Map<String,Integer> mapExamAttempts = mapCountDetails.get(obj.Member__c);
                   system.debug('In First mapExamAttempts == '+mapExamAttempts);
                   //if(obj.Section__c == 'FRM Part 1')
                   Integer iExamCount = mapExamAttempts.get(obj.Section__c);
                   for(String str : mapExamAttempts.keySet())
                   {
                        if((str == 'FRM Part 1' && obj.Section__c == 'FRM Part 2') ||
                            (str == 'FRM Part 2' && obj.Section__c == 'FRM Part 1'))
                      
                        
                        {
                            mapExamAttempts.put('FRM1&FRM2',1);
                            mapExamAttempts.put('FRM Part 1',0);
                            mapExamAttempts.put('FRM Part 2',0);
                        
                        }
                        else
                        {
                           
                           Integer iCount = (iExamCount == null ? 0 : iExamCount)+ 1;
                           mapExamAttempts.put(obj.Section__c,iCount);
                        }
                         system.debug('&&&&&:'+mapExamAttempts); 
                   }
                  
                   
                   system.debug('In First mapExamAttempts 1== '+mapExamAttempts);
                   mapCountDetails.put(obj.Member__c,mapExamAttempts);
               }
               else
               {
                    mapCountDetails.put(obj.Member__c,new Map<String,Integer>{obj.Section__c => 1});
                    system.debug('In First mapCountDetails== '+mapCountDetails);
               }
            }
           else
           {
                mapExamAttemptsForSite.put(obj.Site__c,new Map<Id,Map<String,Integer>>{obj.Member__c => new Map<String,Integer>{obj.Section__c => 1}});
                system.debug('In First mapExamAttemptsForSite== '+mapExamAttemptsForSite);
            
           }
          
           system.debug('***** ' + mapExamAttemptsForSite);
           
           
               
       }
    updateSiteDetails(setSiteIDs,mapExamAttemptsForSite,mapNoOfAttempts);
   }
   
   public Map<String,List<ID>> getExamAttemptsRecords(String setSiteID)
   {
        Map<Id,Map<Id,Map<String,List<ID>>>> mapExamAttemptsForSite = new Map<Id,Map<Id,Map<String,List<ID>>>>();
        Map<Id,Map<String,List<ID>>>  mapCountDetails = null;
        Map<Id,List<ID>> mapNoOfAttempts = new Map<Id,List<ID>>();
        Set<String> setFRM = new Set<String>{'FRM Part 1','FRM Part 2'};
        for(Exam_Attempt__c obj : [select id,Section__c,Site__c,Member__c,Exam_Site__c from Exam_Attempt__c where  Site__c =: setSiteID])
        {
             mapCountDetails = new Map<Id,Map<String,List<ID>>>();
             List<ID> lstMainIDs = (mapNoOfAttempts.get(obj.Site__c) == null ? new List<ID>() : mapNoOfAttempts.get(obj.Site__c));
             lstMainIDs.add(obj.ID);
             mapNoOfAttempts.put(obj.Site__c,lstMainIDs);
             
             
            if(mapExamAttemptsForSite.containsKey(obj.Site__c))
            {
               system.debug('In First == '+mapExamAttemptsForSite);
               mapCountDetails = mapExamAttemptsForSite.get(obj.Site__c);
               system.debug('In First mapCountDetails == '+mapCountDetails);
               if(mapCountDetails.containsKey(obj.Member__c))
               {
                   Map<String,List<ID>> mapExamAttempts = mapCountDetails.get(obj.Member__c);
                   system.debug('In First mapExamAttempts == '+mapExamAttempts);
                   //if(obj.Section__c == 'FRM Part 1')
                   List<ID> lstIDs = mapExamAttempts.get(obj.Section__c) == null ? new List<ID>() : mapExamAttempts.get(obj.Section__c);
                   for(String str : mapExamAttempts.keySet())
                   {
                        if((str == 'FRM Part 1' && obj.Section__c == 'FRM Part 2') ||
                            (str == 'FRM Part 2' && obj.Section__c == 'FRM Part 1'))
                        {
                            lstIDs.add(obj.ID);
                            mapExamAttempts.put('FRM1&FRM2',lstIDs);
                            
                            mapExamAttempts.put('FRM Part 1',null);
                            mapExamAttempts.put('FRM Part 2',null);
                        
                        }
                        else
                        {
                           lstIDs.add(obj.ID);
                           mapExamAttempts.put(obj.Section__c,lstIDs);
                        }
                   }
                  
                   
                   system.debug('In First mapExamAttempts 1== '+mapExamAttempts);
                   mapCountDetails.put(obj.Member__c,mapExamAttempts);
               }
               else
               {
                    List<ID> lstRecIDs = new List<ID>();
                    lstRecIDs.add(obj.ID);
                    mapCountDetails.put(obj.Member__c,new Map<String,List<Id>>{obj.Section__c => lstRecIDs});
                    system.debug('In First mapCountDetails== '+mapCountDetails);
               }
            }
           else
           {
                List<ID> lstRecIDs = new List<ID>();
                    lstRecIDs.add(obj.ID);
                mapExamAttemptsForSite.put(obj.Site__c,new Map<Id,Map<String,List<Id>>>{obj.Member__c => new Map<String,List<Id>>{obj.Section__c => lstRecIDs}});
                system.debug('In First mapExamAttemptsForSite== '+mapExamAttemptsForSite);
            
           }
           }
           
           if(mapExamAttemptsForSite.size() > 0)
           {
                Map<Id,Map<String,List<Id>>> mapExamAttempts = mapExamAttemptsForSite.get(setSiteID);
                Map<String,List<ID>> mapIds = new Map<String,List<ID>>();
                List<ID> lstERP = new List<ID>();
                List<ID> lstFRM1 = new List<ID>();
                List<ID> lstFRM2 = new List<ID>();
                List<ID> lstFRM1_2 = new List<ID>();
                for(ID memID : mapExamAttempts.keySet())
                {
                     system.debug('** TEST ***' + mapExamAttempts.get(memID));
                     if(mapExamAttempts.get(memID).get('ERP') != null)
                        lstERP.addALL(mapExamAttempts.get(memID).get('ERP'));
                     if(mapExamAttempts.get(memID).get('FRM Part 1') != null)
                        lstFRM1.addAll(mapExamAttempts.get(memID).get('FRM Part 1'));
                    if(mapExamAttempts.get(memID).get('FRM Part 2') != null)
                        lstFRM2.addAll(mapExamAttempts.get(memID).get('FRM Part 2'));
                    if(mapExamAttempts.get(memID).get('FRM1&FRM2') != null)
                        lstFRM1_2.addAll(mapExamAttempts.get(memID).get('FRM1&FRM2'));
                    
                    
                }
                mapIds.put('ERP',lstERP);
                mapIds.put('FRM Part 1',lstFRM1);
                mapIds.put('FRM Part 2',lstFRM2);
                mapIds.put('FRM1&FRM2',lstFRM1_2);
                return mapIDs;
            }
       
        return null;
   
   }
   
   public void updateSiteDetails(Set<String> setSiteIDs,Map<Id,Map<Id,Map<String,Integer>>> mapExamAttemptsForSite,Map<Id,Integer> mapTotCounts)
   {
       List<Site__c> lstUpdateSites = new List<Site__c>();
       Integer iERPCount = 0;
       Integer iFRM12Count = 0;
       Integer iFRM1Count = 0;
       Integer iFRM2Count = 0;
       for(Site__c objSite : [select id,No_of_Members_Enrolled__c,No_of_Members_Enrolled_for_ERP__c,No_of_Members_Enrolled_for_FRM1_2__c,No_of_Members_Enrolled_for_FRM1_Only__c,No_of_Members_Enrolled_for_FRM_2_Only__c from Site__c where id in: setSiteIDs])
       {
            iERPCount = 0;
            iFRM12Count = 0;
            iFRM1Count = 0;
            iFRM2Count = 0;
            Map<Id,Map<String,Integer>> mapExamAttempts = mapExamAttemptsForSite.get(objSite.Id);
            system.debug('**mapExamAttempts ** ' + mapExamAttempts);
            if(mapExamAttempts == null) continue;
            for(ID memID : mapExamAttempts.keySet())
            {
                 system.debug('** TEST ***' + mapExamAttempts.get(memID));
                 system.debug('** Site ***' + objSite.Id + ' and ' + mapExamAttempts.get(memID).get('FRM Part 1'));
                 iERPCount += mapExamAttempts.get(memID).get('ERP') == null ? 0 : mapExamAttempts.get(memID).get('ERP');
                 iFRM12Count += mapExamAttempts.get(memID).get('FRM1&FRM2') == null ? 0 : mapExamAttempts.get(memID).get('FRM1&FRM2');
                 system.debug('iFRM1Count Before ' +objSite.Id + ' and ' +iFRM1Count);
                 iFRM1Count += mapExamAttempts.get(memID).get('FRM Part 1') == null ? 0 : mapExamAttempts.get(memID).get('FRM Part 1');
                 system.debug('iFRM1Count after ' +objSite.Id + ' and ' +iFRM1Count);
                 iFRM2Count += mapExamAttempts.get(memID).get('FRM Part 2') == null ? 0 : mapExamAttempts.get(memID).get('FRM Part 2');
                
            }
            //system.debug('iFRM1Count*' +iFRM1Count);
                objSite.No_of_Members_Enrolled_for_ERP__c = String.valueOf(iERPCount);
                objSite.No_of_Members_Enrolled_for_FRM1_2__c = String.valueOf(iFRM12Count);
                objSite.No_of_Members_Enrolled_for_FRM1_Only__c = String.valueOf(iFRM1Count);
                objSite.No_of_Members_Enrolled_for_FRM_2_Only__c = String.valueOf(iFRM2Count);
                objSite.No_of_Exam_Attempts__c = mapTotCounts.get(objSite.Id) == null ? 0 : mapTotCounts.get(objSite.Id);
                objSite.No_of_Members_Enrolled__c = iERPCount+iFRM12Count+math.max( iFRM1Count,iFRM2Count);
            
            lstUpdateSites.add(objSite);
            
       }
       
       if(! lstUpdateSites.isEmpty())
        update lstUpdateSites;
    }
    

  }