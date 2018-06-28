public with sharing class ReportGenerationController {

    public PageReference ExportToExcelClick() {
        PageReference pageRef=new PageReference('/apex/ExportToExcelSheet');
        return pageRef;
    }

    public Map<String,Leads2OppsModel> Data{get;set;}
    public List<Leads2OppsModel> BindableData{get;set;}
    public List<Lead> Leads2Opps{get;set;}
    public ReportGenerationController (){
       
    }
    
    public void LoadReport(){
        Leads2Opps=[Select LeadSource,IsConverted,(SELECT IsWon,StageName FROM Opportunities__r) FROM Lead];
        Data=new Map<String,Leads2OppsModel>();
        for(Lead lead:Leads2Opps)
        {
            if(Data.containsKey(lead.LeadSource))
            {
                Leads2OppsModel temp=Data.get(lead.LeadSource);
                temp.NoOfLeads++;
                if(lead.IsConverted)
                {
                    if(temp.NoOfOpps==null)
                    {
                        temp.NoOfOpps=0;
                    }
                    temp.NoOfOpps++;
                }
                
                for(Opportunity opp:lead.Opportunities__r)
                {
                    if(opp.StageName=='TBC')
                    {
                        if(temp.OppsInTBC==null)
                        {
                            temp.OppsInTBC=0;
                        }
                        temp.OppsInTBC++;
                    }
                    if(opp.StageName=='InSales')
                    {
                        if(temp.OppsInSales==null)
                        {
                            temp.OppsInSales=0;
                        }
                        temp.OppsInSales++;
                    }
                    if(opp.IsWon){
                    	if(temp.OppsWon==null)
                    	{
                        	temp.OppsWon=0;
                    	}
                    	temp.OppsWon++;
                	}
                }
                if(temp.OppsWon!=null&&temp.NoOfLeads!=null&& temp.NoOfLeads>0)
                {
                    temp.ConversionPercentage=(((Decimal)temp.OppsWon/temp.NoOfLeads)*100).setScale(2);
                }
            }
            else
            {
                Data.put(lead.LeadSource,new Leads2OppsModel());
                Leads2OppsModel temp=Data.get(lead.LeadSource);
                temp.LeadSource=lead.LeadSource;
                temp.NoOfLeads=1;
                if(lead.IsConverted)
                {
                    if(temp.NoOfOpps==null)
                    {
                        temp.NoOfOpps=0;
                    }
                    temp.NoOfOpps++;
                }
                for(Opportunity opp:lead.Opportunities__r)
                {
                    if(opp.StageName=='TBC')
                    {
                        if(temp.OppsInTBC==null)
                        {
                            temp.OppsInTBC=0;
                        }
                        temp.OppsInTBC++;
                    }
                     if(opp.StageName=='InSales')
                    {
                        if(temp.OppsInSales==null)
                        {
                            temp.OppsInSales=0;
                        }
                        temp.OppsInSales++;
                    }
                    if(opp.IsWon){
                    	if(temp.OppsWon==null)
                    	{
                        	temp.OppsWon=0;
                    	}
                    	temp.OppsWon++;
                	}
                }
                if(temp.OppsWon!=null&&temp.NoOfLeads!=null&& temp.NoOfLeads>0)
                {
                    temp.ConversionPercentage=(((Decimal)temp.OppsWon/temp.NoOfLeads)*100).setScale(2);
                }
            }
            BindableData=Data.values();
        }
    }
}