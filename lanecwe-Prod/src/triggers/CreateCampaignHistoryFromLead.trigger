/*********************************************************************
Name : CreateCampaignHistoryFromLead 
Created On : feb 09, 2012
Modified on :  feb 15, 2012  
Created By : Lalit Bohra
Description : Trigger on Lead for creating the Campaingn Member on leads.
Task :T-27664,
**********************************************************************/
trigger CreateCampaignHistoryFromLead on Lead (after insert, after update) {
    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
    Boolean isInActiveTrigger = false;
    if(!Test.isRunningTest()){
      isInActiveTrigger = Trigger_Settings__c.getInstance(UserInfo.getProfileId()).InactivateCreateCampaignHistoryFromLead__c;
    }
    
    public set<String> MatchOCC = new set<String>();    
    list<Omniture_Campaign_Code__c> MatchingOmnitureCampaignCode= new list<Omniture_Campaign_Code__c>(); 

    if(isInActiveTrigger == false){
    list<CampaignMember > CampaignMemberList= new list<CampaignMember>();
    String query=null;  
    //set<Id> LeadIds= new set<Id>();
    Map<Id,Lead> leadMap = new Map<Id,Lead>();
    set<String> ExistingCampaignMembersSet= new set<String>();
    Set<String> AllCombinationMatch = new Set<String>();  
    Map<Id,Id> leadCampaignMap = new Map<Id,Id>();
    Map<Id,Lead> oldLeadMap = Trigger.oldMap;
    
    for(Lead ld:trigger.new){   
      if(ld.IsConverted==false && ld.Omniture_Campaign_Code__c != null && ld.Omniture_Campaign_Code__c!=''){
      	if(ld.Omniture_Campaign_Code_No_Match_Found__c != null && ld.Omniture_Campaign_Code__c.contains(ld.Omniture_Campaign_Code_No_Match_Found__c)){
      		continue;
      	}
        //LeadIds.add(ld.Id);
        leadMap.put(ld.Id, ld);
        // Collecting all matches started with Omniture_Campaign_Code__c first sepated : values
        AllCombinationMatch.add(GetFirstString(ld.Omniture_Campaign_Code__c,':'));
      }
    }
    
    //system.debug('----------------------- LeadIds'+LeadIds);
    //system.debug('----------------------- AllCombinationMatch'+AllCombinationMatch);
    
    if(AllCombinationMatch != null && AllCombinationMatch.size()>0){  
      // preparing a set of existing campaign members  
      for(CampaignMember existingCampaignMember:[Select LeadId,CampaignId from CampaignMember where LeadId in :leadMap.keySet()]){
        ExistingCampaignMembersSet.add(existingCampaignMember.LeadId+'~'+existingCampaignMember.CampaignId);
      }
      
      //system.debug('----------------------- ExistingCampaignMembersSet'+ExistingCampaignMembersSet);
      
      // preparing a custom query for fetching records from  Omniture_Campaign_Code__c object       
      query='Select id,Omniture_Campaign_Code__c,Campaign__c from Omniture_Campaign_Code__c where ';
      for(String code:AllCombinationMatch){
        query+=' Omniture_Campaign_Code__c like \''+ code + '%\' OR';
      }
      String finalQuery= query.substring(0, query.length()-2) + 'order by Omniture_Campaign_Code__c desc';
      //system.debug('--------------- finalQuery '+finalQuery);
      
      list<Omniture_Campaign_Code__c> listOmnitureCampaignCode= Database.query(finalQuery);
      
      //system.debug('------------ listOmnitureCampaignCode'+listOmnitureCampaignCode);  
      
      if(listOmnitureCampaignCode != null && listOmnitureCampaignCode.size()>0){
        // We will loop thru all unique Omniture_Campaign_Code__c code from leads and get the campaign id 
        // from listOmnitureCampaignCode and create the campaign member object
        
        for(Lead ld:trigger.new){
          if(ld.Omniture_Campaign_Code__c != null && ld.Omniture_Campaign_Code__c!=''){
            
            set<String> OCCCombinations = new set<String>();
            
            for(String str : GetCombinationsFromString(ld.Omniture_Campaign_Code__c, ':')){
              
              OCCCombinations.clear();
              
              for(Omniture_Campaign_Code__c occ : listOmnitureCampaignCode){
                if(occ.Omniture_Campaign_Code__c.contains(str)){
                  OCCCombinations.add(occ.Campaign__c);
                   MatchOCC.add(occ.Omniture_Campaign_Code__c);  // Added by JP
                }
                
                // Terminating inner loop if sequence changes 
                if(GetFirstString(occ.Omniture_Campaign_Code__c,':') != GetFirstString(str,':')){
                  break;
                }
              }
              
              // Terminating outer loop if any best matches find
              if(OCCCombinations.size() > 0){
                break;
              }
            }
            
            if(OCCCombinations.size() > 0){
            	system.debug('###OCCCombinations='+OCCCombinations);
            	system.debug('###ExistingCampaignMembersSet='+ExistingCampaignMembersSet);
              for(String s : OCCCombinations){
                String concateString=ld.Id + '~' + s;
                //system.debug('----------------------- concateString'+concateString);
                leadCampaignMap.put(ld.Id,s);//Case #53524 - No Match Found list
                system.debug('###leadCampaignMap='+leadCampaignMap);
                if(!ExistingCampaignMembersSet.contains(concateString)){  
                  //system.debug('----------------------- Finally we have some record');              
                  CampaignMember objCampaignMember= new CampaignMember();
                  objCampaignMember.LeadId=ld.Id;
                  objCampaignMember.CampaignId=s;
                  CampaignMemberList.add(objCampaignMember);
                  ExistingCampaignMembersSet.add(concateString);
                }
              }
            }
          }
        }
        
        if(CampaignMemberList != null && CampaignMemberList.size()>0){
          system.debug('---------------- CampaignMemberList'+CampaignMemberList);
          insert CampaignMemberList;
        }        
      }
      
      system.debug('---------MatchOCC----------------'+MatchOCC);
      MatchingOmnitureCampaignCode=[Select id,Omniture_Campaign_Code__c,Campaign__c,Assigned_Lead_Owner_ID__c,Set_Lead_Owner__c from Omniture_Campaign_Code__c 
      where Omniture_Campaign_Code__c IN: MatchOCC];
      system.debug('---------MatchingOmnitureCampaignCode----------------'+MatchingOmnitureCampaignCode);
      system.debug('###leadCampaignMap='+leadCampaignMap);
      
      if(!leadMap.IsEmpty()){
        list<Lead> LeadList= new list<Lead>();
        Lead updateLead;
        for(Lead lead : leadMap.values()){
          updateLead = new Lead(Id = lead.Id);
 
          if(lead.Omniture_Campaign_Code_Copy__c == null || lead.Omniture_Campaign_Code_Copy__c == ''){
            updateLead.Omniture_Campaign_Code_Copy__c=lead.Omniture_Campaign_Code__c;   
              // Added by JP *****************
              if(Trigger.isInsert && (UserInfo.GetUserId()==PGIAppConstants.PGI_INTEGRATION_USERID || UserInfo.GetUserId()==PGIAppConstants.HUBSPOT_INTEGRATION_USERID))
                        {  system.debug('----------------i am integration user ');
                        for(Omniture_Campaign_Code__c O: MatchingOmnitureCampaignCode )
                            { if (O.Set_Lead_Owner__c==true){
                                   system.debug('---------lead.ownerid----before------------'+lead.ownerid);
                                         updateLead.ownerid=O.Assigned_Lead_Owner_ID__c;
                                            system.debug('---------lead.ownerid----after------------'+lead.ownerid);
                                            system.debug('---------O.Assigned_Lead_Owner_ID__c----------------'+ O.Assigned_Lead_Owner_ID__c );
                            }
                            }
                        
                     }  //End JP******************     
          }
          else if(!lead.Omniture_Campaign_Code_Copy__c.Contains( lead.Omniture_Campaign_Code__c)){
            updateLead.Omniture_Campaign_Code_Copy__c=lead.Omniture_Campaign_Code_Copy__c +';'+ lead.Omniture_Campaign_Code__c;          
          }
          //updateLead.Omniture_Campaign_Code__c=null;
          
          //Case #53524 - No Match Found list
          if(!leadCampaignMap.containsKey(lead.Id)){
          	if(lead.Omniture_Campaign_Code_No_Match_Found__c != null && !lead.Omniture_Campaign_Code_No_Match_Found__c.contains(lead.Omniture_Campaign_Code__c)){
          		updateLead.Omniture_Campaign_Code_No_Match_Found__c = lead.Omniture_Campaign_Code_No_Match_Found__c + ';' + lead.Omniture_Campaign_Code__c;
          	}
          	else{
          		updateLead.Omniture_Campaign_Code_No_Match_Found__c = lead.Omniture_Campaign_Code__c;
          	}
          }
          else{
          	updateLead.Omniture_Campaign_Code__c=null;	//clear value only if match is found
          }
          
          LeadList.add(updateLead);
        }
        system.debug('---------------- LeadList'+LeadList);
        update LeadList;
      }  
    }
    }
    
  private List<String> GetCombinationsFromString(String Value,String Separator){
    List<String> Combinations= new List<String>();  
    Combinations.add(Value);
      
    try{
      if(Value.contains(Separator)){
        for(Integer iCount=Value.Length();iCount>0;iCount--){
          String s=Value.substring(iCount-1,iCount);          
          if(s==Separator){
            String Temp=Value.substring(0,iCount);
            String Temp2 = Temp.substringBeforeLast(Separator);
            if(Temp2.contains(Separator)){		//Case #51621 - Remove last level match
            	Combinations.add(Temp);
            }
          }
        }
      }
    }
    catch(exception ex){
      system.debug('------------  exception '+ex);
    }
      
    system.debug('------------  Combinations '+Combinations);
    return Combinations;
  }    
  
  private String GetFirstString(String Value,String Separator){
    try{
      if(Value.contains(Separator)){
        return Value.split(Separator).get(0) + Separator;          
      }
    }
    catch(exception ex){
      system.debug('------------  exception '+ex);
    }
    return Value;
  }  
    
}