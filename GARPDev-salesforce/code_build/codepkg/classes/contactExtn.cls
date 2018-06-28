public class contactExtn
{
    public Exam_Attempt__c objEA{get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string email{get;set;}
    public string nickname{get;set;}
    public string title{get;set;}
    Public string mode{get;set;}
    Public Boolean close{get;set;}
    Public string amount{get;set;}
    
    public contactExtn(Apexpages.Standardcontroller std)
    {
        mode='Comp';
        objEA = (Exam_Attempt__c)std.getRecord();
    
    }

    public contactExtn(Exam_Attempt__c objEAIn, String amountIn, Boolean closeOpp)
    {
        mode='Event';
        amount=amountIn;
        objEA = objEAIn;
        close = closeOpp;
    
    }
    
    public pageReference createContact()
    {   
        try
        {
            Contact objCon = [select id,email from contact where email =: email];
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Contact with the email is already present.');
            ApexPages.addMessage(myMsg);


        }
        catch(exception ex)
        {
            createAccount();

        }

        return null;
    }

    private void createAccount()
    {
        Account objAcc = new Account(name=firstName+ ' ' + lastName);
        objAcc.recordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
        insert objACC;

        Contact objCon = new Contact(firstName=firstName,lastName=lastName,Email=email,Title=title,Nickname__c = nickName,accountId = objAcc.Id);
        objCon.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        insert objCon;

        Opportunity objOpp = createOpportunity(objCon,'Affiliate Membership',true);
        createOppLineItems(objOpp.Id,'AFREE','4999',objCon,null);
        objOpp.StageName = 'Closed';
        update objOpp;

        Id contractID = createContract(objAcc.Id,objOpp.Id,objCon.Id,'Affiliate', true);

    }

    private id createContract(Id accId,Id oppId, Id contactId, String memberType, Boolean activateContract)
    {
        Contract objContract = new Contract();
        objContract.accountId = accId;
        objContract.CustomerSignedId = contactId;
        objContract.Opportunity__c = oppId;
        objContract.StartDate = system.today();
        objContract.ContractTerm  = 12;
        objContract.Status = 'Draft';
        objContract.Membership_Type__c = memberType;
        objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        insert objContract;    
        
        if(activateContract) {
            Contract objUpdate = [select id,Status from Contract where id =: objContract.Id];
            objUpdate.Status = 'Activated';
            update objUpdate;
            return objUpdate.Id;
        } else {
            return objContract.Id;
        }
        
    }
    
    public pageReference updateMemberShip()
    {
        Contact objContact = [select id,name,accountId from Contact where id =: objEA.Member__c];
        Opportunity objOpp = new Opportunity();      
        if(mode == 'Comp') {
            objOpp = createOpportunity(objContact,'Complementry Membership', true);
            //Id contractID = createContract(objContact.accountId,objOpp.Id, objContact.Id,'Individual',false);
            
            createOppLineItems(objOpp.Id,'MEMF','4040',objContact, null); 
            objOpp.StageName = 'Closed';
            update objOpp;
            
        } else {
                        
            objOpp = createOpportunity(objContact,'Event Registration', false);
            createOppLineItems(objOpp.Id,'CNY13','4060',objContact, amount);    
            objOpp.StageName = 'Closed';
            update objOpp;

            objOpp = createOpportunity(objContact,'Event Membership', false);
            //Id contractID = createContract(objContact.accountId,objOpp.Id, objContact.Id,'Individual',false);
            
            createOppLineItems(objOpp.Id,'MEMI','4040',objContact, null);  
            if(close)
                objOpp.StageName = 'Closed';
            update objOpp;

        }
        
        return null;
    
    }
    
    public Opportunity createOpportunity(Contact objContact, String name, Boolean Membership)
    {
        
        Opportunity opp = new Opportunity();
        try
        {
            opp.Name = name;
            opp.Accountid = objContact.AccountId;
            opp.StageName = 'New Lead';
            opp.CloseDate = system.today();
            opp.Eligible_for_Membership_Extension__c= true;
            insert opp;
            
            OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=objContact.Id, Role='Decision Maker');
            insert contactRole;
            
             system.debug('* * * opp:'+ opp);
            
            return opp;
        }
        catch(exception ex)
        {
            return null;
        }
        
    
    }

    public  void createOppLineItems(Id oppId,String strProdCode, String glCode, Contact objContact, String price)
    {
        //if(mapProdDetails == null) return;
        String strNameByProdcutCode  = '';
        PriceBookEntry PricebookEntryId = [select unitprice,productcode,Product2.GL_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode =: strProdCode and Product2.GL_Code__c = :glCode and isActive =: true];
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppId;
        oppLineItem.PricebookEntryId = PricebookEntryId.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.UnitPrice = PricebookEntryId.unitprice;
        if(price != null) {
            oppLineItem.UnitPrice = Decimal.valueOf(price);
        }
        
        system.debug('* * * oppLineItem:'+ oppLineItem);
        
        insert oppLineItem;
    }
}