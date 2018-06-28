public with sharing class OpportunityImplementationAutomation {

public String OpportunityName { get; set; }
public String OpportunityID { get; set; }
public list<Opportunity> SearchedOpportunities {get; set;}
public List<oOpportunity> OpportunityList {get; set;}
public List<Implementation_Services__c> ImplementationInsertList {get;set;}
public boolean Flag=false;
Public String OpportunityRefID;
private String sortDirection = 'ASC';
private String sortExp = 'name';
private List<Opportunity> SortListOpportunity;
private String currentUserRegion;
private String currentUserChannel;
      
 // **** Constructor******
 
 public OpportunityImplementationAutomation() {
 //system.debug('--Inside Constructor--');
	User currentUser = [Select Id, Region__c, Channel__c From User Where Id=:Userinfo.getUserId()];
	currentUserRegion = currentUser.Region__c;
	currentUserChannel = currentUser.Channel__c;
	//if (PGIAppConstants.USER_REGIONS[1].equals(currentUserRegion))
	if (currentUserRegion == 'NA')
	{
		if (PGIAppConstants.USER_CHANNEL_CANADA.equals(currentUserChannel))
		{
			SearchedOpportunities =[Select Count_of_Quote__c,
								owner.name,
								account.name,
								Opportunity_Number__c,
								id,
								type,
								Implementation_Review_Request__c,
								Name,
								AccountId,
								OwnerId,
								Owner_Region_New__c,
								Channel_New__c,
								Opp_Stage__c,
								CloseDate,Amount__c,
								Total_Annual_Value__c,
								MRR_Total__c 
						from Opportunity 
						where IST_Eligible__c='Yes' 
								and Count_of_Implementation_Services__c=0 
								and Related_Implementation_Record__c =null 
								and Owner_Region__c=:currentUserRegion
								and Channel__c=:currentUserChannel LIMIT 500];
		}
		else
		{
			SearchedOpportunities =[Select Count_of_Quote__c,
								owner.name,
								account.name,
								Opportunity_Number__c,
								id,
								type,
								Implementation_Review_Request__c,
								Name,
								AccountId,
								OwnerId,
								Owner_Region_New__c,
								Channel_New__c,
								Opp_Stage__c,
								CloseDate,Amount__c,
								Total_Annual_Value__c,
								MRR_Total__c 
						from Opportunity 
						where IST_Eligible__c='Yes' 
								and Count_of_Implementation_Services__c=0 
								and Related_Implementation_Record__c =null 
								and Owner_Region__c=:currentUserRegion
								and Channel__c!=:PGIAppConstants.USER_CHANNEL_CANADA LIMIT 500]; 
		}
	}
	else
	{
		if (PGIAppConstants.USER_CHANNEL_CANADA.equals(currentUserChannel)){
		SearchedOpportunities =[Select Count_of_Quote__c,
					owner.name,
					account.name,
					Opportunity_Number__c,
					id,
					type,
					Implementation_Review_Request__c,
					Name,
					AccountId,
					OwnerId,
					Owner_Region_New__c,
					Channel_New__c,
					Opp_Stage__c,
					CloseDate,Amount__c,
					Total_Annual_Value__c,
					MRR_Total__c 
			from Opportunity 
			where IST_Eligible__c='Yes' 
					and Count_of_Implementation_Services__c=0 
					and Related_Implementation_Record__c =null 
					and Owner_Region__c=:currentUserRegion LIMIT 500]; 
		}
		else{
			SearchedOpportunities =[Select Count_of_Quote__c,
					owner.name,
					account.name,
					Opportunity_Number__c,
					id,
					type,
					Implementation_Review_Request__c,
					Name,
					AccountId,
					OwnerId,
					Owner_Region_New__c,
					Channel_New__c,
					Opp_Stage__c,
					CloseDate,Amount__c,
					Total_Annual_Value__c,
					MRR_Total__c 
			from Opportunity 
			where IST_Eligible__c='Yes' 
					and Count_of_Implementation_Services__c=0 
					and Related_Implementation_Record__c =null 
					and Owner_Region__c=:currentUserRegion 
					and Channel__c!=:PGIAppConstants.USER_CHANNEL_CANADA LIMIT 500]; 
		}
	}
 
    system.debug('------SearchedOpportunities inside constructor ------'+SearchedOpportunities );  
      system.debug('------SearchedOpportunities Size ------'+SearchedOpportunities.size() );  
      
         if(SearchedOpportunities.size() >0) {
            OpportunityList = new List<oOpportunity>();
            for(Opportunity c: SearchedOpportunities ) {
                // As each Opportunity is processed we create a new oOpportunity object and add it to the OpportunityList
                OpportunityList.add(new oOpportunity(c));
            }  Flag=true;
        }
}
    
   public String sortExpression
   {
     get
     {  system.debug('..sortExp..'+sortExp);
         
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       system.debug('..value..'+value);
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }  
   
    public String getSortDirection()
     {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
     }  
     
      public void setSortDirection(String value)
     {  
       sortDirection = value;
     } 
 
   //************ method that is called when user clicks on column to sort
    public pagereference ViewData() 
    { //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
       string ISTEligible='yes';
		//if (PGIAppConstants.USER_REGIONS[1].equals(currentUserRegion))
		if(currentUserRegion == 'NA')
		{
			if (PGIAppConstants.USER_CHANNEL_CANADA.equals(currentUserChannel))
			{
				SearchedOpportunities =Database.query('Select Count_of_Quote__c,'+
									  'owner.name,account.name,'+
									  'type,Opportunity_Number__c,'+
									  'id,Implementation_Review_Request__c,'+
									  'Name,AccountId,OwnerId,Owner_Region_New__c,'+
									  'Channel_New__c,Opp_Stage__c,CloseDate,Amount__c,'+
									  'Total_Annual_Value__c,MRR_Total__c '+
									  'from Opportunity '+
									  'where IST_Eligible__c=\'Yes\' '+
									  'and Count_of_Implementation_Services__c=0 '+
									  'and Related_Implementation_Record__c =null '+
									  'and Owner_Region__c=\''+currentUserRegion+ '\' '+
									  'and Channel__c=\''+currentUserChannel+ '\' '+
									  'order by ' + sortFullExp + ' limit 500');
			}
			else
			{
		        SearchedOpportunities =Database.query('Select Count_of_Quote__c,'+
									  'owner.name,account.name,'+
									  'type,Opportunity_Number__c,'+
									  'id,Implementation_Review_Request__c,'+
									  'Name,AccountId,OwnerId,Owner_Region_New__c,'+
									  'Channel_New__c,Opp_Stage__c,CloseDate,Amount__c,'+
									  'Total_Annual_Value__c,MRR_Total__c '+
									  'from Opportunity '+
									  'where IST_Eligible__c=\'Yes\' '+
									  'and Count_of_Implementation_Services__c=0 '+
									  'and Related_Implementation_Record__c =null '+
									  'and Owner_Region__c=\''+currentUserRegion+ '\' '+
									  'and Channel__c!=\''+PGIAppConstants.USER_CHANNEL_CANADA+ '\' '+
									  'order by ' + sortFullExp + ' limit 500');
			}
		}
		else
		{
			if (PGIAppConstants.USER_CHANNEL_CANADA.equals(currentUserChannel))
			{
	        	SearchedOpportunities =Database.query('Select Count_of_Quote__c,'+
									  'owner.name,account.name,'+
									  'type,Opportunity_Number__c,'+
									  'id,Implementation_Review_Request__c,'+
									  'Name,AccountId,OwnerId,Owner_Region_New__c,'+
									  'Channel_New__c,Opp_Stage__c,CloseDate,Amount__c,'+
									  'Total_Annual_Value__c,MRR_Total__c '+
									  'from Opportunity '+
									  'where IST_Eligible__c=\'Yes\' '+
									  'and Count_of_Implementation_Services__c=0 '+
									  'and Related_Implementation_Record__c =null '+
									  'and Owner_Region__c=\''+currentUserRegion+ '\' '+
									  'order by ' + sortFullExp + ' limit 500');
			}
			else
			{
				SearchedOpportunities =Database.query('Select Count_of_Quote__c,'+
									  'owner.name,account.name,'+
									  'type,Opportunity_Number__c,'+
									  'id,Implementation_Review_Request__c,'+
									  'Name,AccountId,OwnerId,Owner_Region_New__c,'+
									  'Channel_New__c,Opp_Stage__c,CloseDate,Amount__c,'+
									  'Total_Annual_Value__c,MRR_Total__c '+
									  'from Opportunity '+
									  'where IST_Eligible__c=\'Yes\' '+
									  'and Count_of_Implementation_Services__c=0 '+
									  'and Related_Implementation_Record__c =null '+
									  'and Owner_Region__c=\''+currentUserRegion+ '\' '+
									  'and Channel__c!=\''+PGIAppConstants.USER_CHANNEL_CANADA+ '\' '+
									  'order by ' + sortFullExp + ' limit 500');
			}
		}
			

 
           OpportunityList = new List<oOpportunity>();
            
            for(Opportunity c: SearchedOpportunities ) 
            {
                OpportunityList.add(new oOpportunity(c));
            }
            
             return null; 
       }


// **** Opportunity Wrapper Class***

public class oOpportunity {
        public Opportunity con {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new oOpportunity object we pass a Opportunity that is set to the con property. We also set the selected value to false
        public oOpportunity(Opportunity c) {
            con = c;
            selected = false;
        }
    }


//**** Class to create a child implementation record for the selected opportunity. On click of New Automated Button



public PageReference CreateImpSerRecord() {

  system.debug('------Inside CreateImpSerRecord Method ------');  

List<Opportunity> selectedOpportunitys = new List<Opportunity>();

        //We will cycle through our list of oOpportunitys and will check to see if the selected property is set to true, if it is we add the Opportunity to the selectedOpportunitys list
        
        if(Flag==true) {
       
        for(oOpportunity cCon:OpportunityList) {
           system.debug('------Inside For Loop ------'); 
            if(cCon.selected == true) {
             system.debug('------Inside If Loop ------'); 
                selectedOpportunitys.add(cCon.con);
            }
        }
        

        // Now we have our list of selected Opportunitys and can perform any type of logic we want, sending emails, updating a field on the Opportunity, etc
        System.debug('These are the selected Opportunitys...');
        for(Opportunity con: selectedOpportunitys) {
            system.debug(con);
        }
        
         system.debug('------selectedOpportunitys------'+selectedOpportunitys);  
         
           if(selectedOpportunitys.size()>0)
            {  system.debug('### -- Got some selected records' );
     
               for(Opportunity oo: selectedOpportunitys)
                {  
                      Implementation_Services__c Imp =new Implementation_Services__c();
          
                      //Imp.Implementation_Owner__c='005e0000001YTG5';
                      Imp.Implementation_Owner__c='005a000000AoISB';
                      Imp.Implementation_Type__c='N/A';
                      Imp.IST_Status__c=  'No IS Assigned';
                      Imp.IST_Completed_Status__c ='No IS Assigned';
                      Imp.Related_Opportunity__c=oo.id;         
                    
                      Insert Imp;
                      //ImplementationInsertList.add(Imp) ;
               }     
    
               /*  if(ImplementationInsertList.size()>0)
            {   Insert ImplementationInsertList;
            } */
     
             }
      }
      
       if(Flag==false  ) {
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Atleast one or more opportunities should be selected to perform this operation. Please select opportunities after finding some records'));
          return null;
       }
       
        if(selectedOpportunitys.size()==0) {
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Atleast one or more opportunities should be selected to perform this operation. Please select opportunities after finding some records'));
          return null;
       }
  PageReference ref = Page.OpportunityImplementationAutomation;
  ref.setRedirect(true);
  return ref;


}



public PageReference GoToOpportunityLink() {
   
      OpportunityRefID=System.currentPageReference().getParameters().get('OpportunityRefID');
      
      system.debug('------OpportunityRefID------'+OpportunityRefID); 
         PageReference pageRef = new PageReference('/'+OpportunityRefID);
        
          return pageRef ;
    }

// ******************* Test Class***********************************

    public static testMethod void TestGoToOpportunityLink(){
     
        test.starttest(); 
       
        Account acc= new Account();
        acc.Name='Test Acc';
        acc.Status__c='Prospect';
        acc.ChannelType__c='Reseller';
        insert acc;
         
        Contact con= new Contact(); 
        con.LastName='Conlastname';
        con.AccountId=acc.Id;
        insert con;
       
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.today();
        opp.stagename = 'Qualification';
        opp.CurrencyIsoCode = 'USD';        
        opp.Probability = 0;
        opp.Contact__c=con.Id;
        // opp.Implementation_Review_Request__c = True;
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'test 1';
        opp1.AccountId = acc.Id;
        opp1.CloseDate = system.today();
        opp1.stagename = 'Qualification';
        opp1.CurrencyIsoCode = 'USD';        
        opp1.Probability = 0;
        opp1.Contact__c=con.Id;
        // opp1.Implementation_Review_Request__c = True;
        insert opp1;
        
        
        
        String OpportunityRefID;
        OpportunityRefID=opp.id;
        
       // PageReference pageRef = new PageReference('/'+OpportunityRefID);
       //  Test.setCurrentPage(pageRef );
       OpportunityImplementationAutomation notificationcnt=new OpportunityImplementationAutomation();
       system.assert(notificationcnt.GoToOpportunityLink()!=null);
        
       /*Cover wrapper code*/
                 
       notificationcnt.viewdata();
       notificationcnt.CreateImpSerRecord();
       notificationcnt.getSortDirection();
       notificationcnt.setSortDirection('name');
       notificationcnt.setSortDirection('ASC');
       notificationcnt.GoToOpportunityLink();
        
        
       // PageReference pageRef = new PageReference('/'+OpportunityRefID);
       //  Test.setCurrentPage(pageRef );
       OpportunityImplementationAutomation notificationcnt1=new OpportunityImplementationAutomation();
       system.assert(notificationcnt1.GoToOpportunityLink()!=null);
        
       User U1 = [Select Id from User where channel__c<>:'Canada' AND IsActive=:true LIMIT 1];
       system.runas(U1) {
       /*Cover wrapper code*/
                 
       notificationcnt1.viewdata();
       notificationcnt1.CreateImpSerRecord();
       notificationcnt1.getSortDirection();
       notificationcnt1.setSortDirection('name');
       notificationcnt1.setSortDirection('ASC');
       notificationcnt1.GoToOpportunityLink();
       }
        
       test.stoptest();
    }
    
    /*
    public static void TestCreateImpSerRecord(){
    	test.starttest();
    	OpportunityImplementationAutomation oppImpAutomation = new OpportunityImplementationAutomation();
    	List<Opportunity> oppList = new List<Opportunity>();
    	List<oOpportunity> oOppList = new List<oOpportunity>();
    	for (integer i=0; i<20; i++){
    		Opportunity opp = PGITestUtilities.getOpportunityDetails();
    		oppList.add(opp);
    		oOpportunity oOpp = new oOpportunity(opp);
    		oOpp.selected = true;
    		oOppList.add(oOpp);
    	}
    	insert oppList;

    	oppImpAutomation.OpportunityList = oOppList;
    	try{
    	oppImpAutomation.CreateImpSerRecord();
    	List<Implementation_Services__c> impSerList = [Select id from Implementation_Services__c where Related_Opportunity__c = :oppList];
    	system.debug('###impSerList.size='+impserList.size());
    	system.assertEquals(impSerList.size(),oppList.size());
    	}
    	catch(Exception ex){
    		system.debug('###error ex='+ex);
    	}   
    	test.stoptest();	
    }*/
       
       




}