public with sharing class addtocampaigns_Extension {

//variables used on Visual force page for interaction with end user
public Lead ParticipantLead {get; set;}  //Lead record returned based on Id (pid) query parameter from custom button 
public Contact ParticipantContact {get; set;} //Contact record returned based on Id (pid) query parameter from custom button
public string ParticipantId {get;set;}  //Value of Query parameter pid      
public list<addtocampaigns_Wrapper> Campaign_List=new list<addtocampaigns_Wrapper>(); //List of campaign records to be used for selection
public Boolean SubmitDisabled {get;set;}  //[Submit] button and [Select All] button can be used just ones 
public AddtoCampaignsSetting__c  mySetting {get; set;} //Custom Setting for logged user          

public addtocampaigns_Extension(ApexPages.StandardController controller) {
        //Standard controller extensin used to add custom functionality to visual force page 
        ParticipantId=System.currentPageReference().getParameters().get('pid');
        mySetting=AddtoCampaignsSetting__c.getInstance();//Custom Setting Definitions
        getParticipant();  //get Participant data from Lead or Contact
        getCampaign_List();//get list for campaign selection 
}
    
public ApexPages.StandardSetController con {
        //Standard Set controller used to add custom functionality to visual force page
        //and laverage standard behavior of List View filters 
        get {
            if(con == null) {
                //Standard set controller query used to retrieve data from Campaign object
                //used on visual force page to select potential campaigns
                integer myLimit=integer.valueOf(mySetting.RecordSet_Limit__c);
                if (myLimit==null){
                    myLimit=200;
                }
                con = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [Select Id, Name, StartDate,EndDate, Type, Status, ParentId, RecordTypeId     
                        FROM Campaign 
                        order By Name,StartDate 
                        limit :myLimit]));
                
                //in order to use it again you need to refresh page or go back to participant and start again
                //set filter id that is applied for Hierarchy setting Org/Profile/User
                if (mySetting.ListViewId__c!=null){
                    //Filter Magic is heppening here 
                    con.setFilterID(mySetting.ListViewId__c);
                    con.setPageSize(myLimit);
                }
            }
            return con;
        }
        set;
}    

public List<addtocampaigns_Wrapper> getCampaign_List() {
    //get list for campaign selection 
    if (Campaign_List.Size()==0){
        //Load campign list just ones on first page load
        //(List<Campaign>)con.getRecords()) will execute query and 
        //apply defined mySetting.ListViewId__c as filter to set of records
        for (Campaign camp: (List<Campaign>)con.getRecords()){
            Campaign_List.add(new addtocampaigns_Wrapper(camp));
            
            //check if participant is already part of campaign and disable it for selection
            if (ParticipantId.startsWith('00Q')){
                //process lead campaign member records
                for (CampaignMember CM :ParticipantLead.CampaignMembers){
                    if (CM.CampaignId==camp.Id && Campaign_List.Size()>0){
                        //disable check box on visual force page 
                        Campaign_List[Campaign_List.size()-1].disabled=true;
                        break;
                    }
                }   
            }else{
                //process contact campaign member records
                for (CampaignMember CM :ParticipantContact.CampaignMembers){
                    if (CM.CampaignId==camp.Id && Campaign_List.Size()>0){
                        //disable check box on visual force page 
                        Campaign_List[Campaign_List.size()-1].disabled=true;
                        break;
                    }
                }
            }
        }
    }
    return Campaign_List; 
}

public void getParticipant() {
    //get Participant data from Lead or Contact
    //run it just ones on first page load 
    if (ParticipantLead==null && ParticipantContact==null){
        SubmitDisabled=false;
        //Query lead
        if (ParticipantId.startsWith('00Q')){
            ParticipantLead=[Select l.Street, 
                                    l.State, 
                                    l.PostalCode, 
                                    l.Phone, 
                                    l.Name, 
                                    l.LastName, 
                                    l.Id, 
                                    l.FirstName, 
                                    l.Email, 
                                    l.Country, 
                                    l.City,
                                    l.Company,
                                    (Select Id,
                                         CampaignId
                                     From CampaignMembers
                                     where IsDeleted=false  
                                     order by CreatedDate DESC  ) 
                                From Lead l
                                where l.Id=:ParticipantId  
                            ];
            ParticipantContact=new Contact();   
        }
        else if (ParticipantId.startsWith('003')){
            //Query Contact
            ParticipantContact=[Select  c.Phone,
                                        c.Name, 
                                        c.MailingStreet, 
                                        c.MailingState, 
                                        c.MailingPostalCode, 
                                        c.MailingCountry, 
                                        c.MailingCity, 
                                        c.LastName, 
                                        c.IsDeleted, 
                                        c.Id, 
                                        c.FirstName, 
                                        c.Email, 
                                        Account.Name,
                                        (Select Id, 
                                                CampaignId 
                                            From CampaignMembers
                                            where IsDeleted=false 
                                            order by CreatedDate DESC )
                                 From Contact c
                                 where c.Id=:ParticipantId  
                            ];
            ParticipantLead=new Lead(); 
        }
    }
    return;
}
public PageReference GoToParticipant() {
    //[Back] button setting 
    PageReference pageRef=new PageReference('/'+ParticipantId);
    pageRef.setRedirect(true);
    return pageRef; 
}
public PageReference Submit() {
    //[Submit] button logic
    PageReference pageRef;
    //list for insert campaign members
    list<CampaignMember> Insert_CampaignMembers =new list<CampaignMember>();
    //iteration throught offered campaigns and generate campaign member records
    for (addtocampaigns_Wrapper camp: Campaign_List){
        if (camp.checked){
            //generate campaign member record
            CampaignMember CM = new CampaignMember();
            CM.CampaignId=camp.camp.Id;
            if (ParticipantId.startsWith('00Q')){
                //Lead campaign member
                CM.LeadId=ParticipantId;
            }else{
                //contact campaign member
                CM.ContactId=ParticipantId;
            }
            //add to the list for insert
            Insert_CampaignMembers.add(CM);
        }
    }
    //if anything was selected execute DML 
    if (Insert_CampaignMembers.size()>0){
        try{
            insert (Insert_CampaignMembers);
            SubmitDisabled=true;
            //Success message to end user
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 
                   mySetting.message_Success__c+' ('+ Insert_CampaignMembers.size().format() + ').');
            ApexPages.addMessage(msg);
        } catch (DMLException e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
               mySetting.message_Error__c + e);
            ApexPages.addMessage(msg);
        }
    }else {
        //Validation Message to end user
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 
              mySetting.message_Validation__c );
            ApexPages.addMessage(msg);
    }
    return pageRef; 
}
public PageReference SelectAll() {
    //[Select All] button logic
    PageReference pageRef;
    //itterate throught offered campaigns and sellect all that aren't in use already
    for (addtocampaigns_Wrapper camp: Campaign_List){
        if (camp.disabled==false){
            camp.checked=true;
        }
    }
    return pageRef; 
}
public PageReference FilterSetting() {
    //[Back] button setting 
    PageReference pageRef=new PageReference('/apex/addtocampaigns_listviewfilter');
    pageRef.setRedirect(true);
    return pageRef; 
}
}//end of class