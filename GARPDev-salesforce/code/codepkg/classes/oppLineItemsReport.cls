public class oppLineItemsReport
{
    public Opportunity oppFilters{get;set;}
    public boolean bIsRegular{get;set;}
    public boolean bIsTax{get;set;}
    public boolean bIsGRA{get;set;}
    public boolean bIsGARP{get;set;}
    public oppLineItemsReport()
    {
        oppFilters = new Opportunity();
    }
    
    public pageReference generateCSV()
    {
        boolean bThrowMessage = false;
        if(oppFilters.Report_Start_Date__c == null || oppFilters.Report_End_Date__c == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter Start/End Dates'));
            bThrowMessage = true;
            //return null;
        }
        if(!bIsTax && !bIsRegular)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please Select Tax or Regular.'));
            bThrowMessage = true;
        }
         if(!bIsGRA && !bIsGARP)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please Select GRA or GARP.'));
            bThrowMessage = true;
        }
        if(bThrowMessage)
         return null;
        PageReference pageRef;
        String strCompanyName = '';
        if(bIsGRA) strCompanyName = 'GRA';
        else if(bIsGARP) strCompanyName = 'GARP';
        if(bIsTax)
        {
             pageRef = new PageReference('/apex/CsvForTax?stDate='+oppFilters.Report_Start_Date__c+'&endDate='+oppFilters.Report_End_Date__c+'&Taxable='+bIsTax+'&Regular='+bIsRegular+'&Company='+strCompanyName);
       
        }
        else
        {
             pageRef = new PageReference('/apex/oppCSV?stDate='+oppFilters.Report_Start_Date__c+'&endDate='+oppFilters.Report_End_Date__c+'&Company='+strCompanyName);
       
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    

}