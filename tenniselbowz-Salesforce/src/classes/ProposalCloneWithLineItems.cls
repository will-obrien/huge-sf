public with sharing class ProposalCloneWithLineItems {
    
    public Apttus_Proposal__Proposal__c aptsProposal = new Apttus_Proposal__Proposal__c(); 
    public Apttus_Proposal__Proposal__c clonedProposal = new Apttus_Proposal__Proposal__c();
    
    public List<Apttus_Proposal__Proposal_Line_Item__c> aptsProposalLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    public List<Apttus_Proposal__Proposal_Line_Item__c> clonedLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    
    public id ProposalId = null;
    //Constructor
    public ProposalCloneWithLineItems(ApexPages.StandardController controller) { 
        aptsProposal = (Apttus_Proposal__Proposal__c)controller.getRecord(); 
        ProposalId = aptsProposal.id;
    } 
    
    public PageReference clones(){ 
        //aptsProposal = [select id  from Apttus_Proposal__Proposal__c where id=: aptsProposal.id];
        
        //Building Dynamic SOQL Query to pull the Quote Record
        
        String ProposalSelects = '';
        Map<String, Schema.SObjectField> f1Map = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal__c').getDescribe().Fields.getMap();
        list<string> select1Fields = new list<string>();
         
        if (f1Map != null){
            for (Schema.SObjectField f1t : f1Map.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult f1d = f1t.getDescribe(); // describe each field (fd)
                if (f1d.isCreateable()){ // field is creatable
                    select1Fields.add(f1d.getName());
                }
            }
        }
         
        if (!select1Fields.isEmpty()){
            for (string s:select1Fields){
                ProposalSelects += s + ',';
            }
            if (ProposalSelects.endsWith(',')){ProposalSelects = ProposalSelects.substring(0,ProposalSelects.lastIndexOf(','));}
             
        }
        String query1built = 'SELECT ' + ProposalSelects + ' FROM ' + 'Apttus_Proposal__Proposal__c' + ' WHERE Id =: ProposalId ' ;
        //aptsProposalLineItems=[SELECT Id,Apttus_Proposal__Product__c, List_price_Per_Unit__c, APTPS_Selling_Price__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__r.Id =: aptsProposal.id];
        aptsProposal=Database.query(query1built);
       
        clonedProposal = aptsProposal.clone(false, TRUE, false, false);
        clonedProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
        clonedProposal.LA_Approval_Status__c = 'Not Submitted';
        clonedProposal.Margin_Approval_Status__c = 'Needs Review';
        clonedProposal.Reserve_Approval_Status__c = 'Needs Review';
        clonedProposal.APTPS_LA_Submit_for_Approval__c = FALSE;
        clonedProposal.Apttus_Proposal__Primary__c = FALSE;
        clonedProposal.Quote_Lock_Status__c = 'Unlocked';
        clonedProposal.Clone__c =TRUE;
        insert clonedProposal;
        
        // Get a map of field name and field token
        String selects = '';
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal_Line_Item__c').getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
        String querybuilt = 'SELECT ' + selects + ' FROM ' + 'Apttus_Proposal__Proposal_Line_Item__c' + ' WHERE Apttus_Proposal__Proposal__r.Id =: ProposalId ' ;
        //aptsProposalLineItems=[SELECT Id,Apttus_Proposal__Product__c, List_price_Per_Unit__c, APTPS_Selling_Price__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__r.Id =: aptsProposal.id];
        aptsProposalLineItems=Database.query(querybuilt);
        for(Apttus_Proposal__Proposal_Line_Item__c lineitem : aptsProposalLineItems){
            Apttus_Proposal__Proposal_Line_Item__c cloneItNow = lineitem.clone(FALSE, TRUE, FALSE, FALSE);
            cloneItNow.Apttus_Proposal__Proposal__c = clonedProposal.id;
            clonedLineItems.add(cloneItNow);
        }
        if(clonedLineItems.size()>0)
        insert clonedLineItems;
        
        PageReference pr = new ApexPages.StandardController(clonedProposal).view(); 
        system.debug('>>>>>>>>'+pr); 
        return pr; 
         
    } 
    
    
 

}