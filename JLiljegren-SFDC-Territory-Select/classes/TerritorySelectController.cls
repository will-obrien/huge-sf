public class TerritorySelectController
{
    private Opportunity thisOpp;
    private List<SelectOption> items;
    private Map<Id, Territory> territoryMap;
    private String selectedTerritory;
    public String paramOppId { get; set; }

    public TerritorySelectController()
    {
        paramOppId = System.currentPageReference().getParameters().get('Id');
    }

    public String getSelectedTerritory()
    {
        if ( thisOpp.TerritoryId != null )
        {
            selectedTerritory = thisOpp.TerritoryId;
        }
        else
        {
            selectedTerritory = '';
        }

        return selectedTerritory;
    }
    
    public void setSelectedTerritory(String inTerr)
    {
        this.selectedTerritory = inTerr;
    }
    
    public List<SelectOption> getItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Set<Id> terrIDs = new Set<Id>();
        List<UserTerritory> userTerrs = new List<UserTerritory>([select TerritoryId from UserTerritory
                                                                 where (UserId = :Userinfo.getUserId() or UserId = :thisOpp.OwnerId) and IsActive=True]);
        for ( UserTerritory ut : userTerrs )
        {
            terrIDs.add(ut.TerritoryId);
        }
        
        if ( thisOpp.TerritoryId != null )
        {
            terrIDs.add(thisOpp.TerritoryId);
        }

        territoryMap = new Map<Id, Territory>([select id, name, Territory_Inactive__c from Territory where Id in :terrIDs and ParentTerritoryId <> null]);
        
        for ( Territory t : territoryMap.values() )
        {
            if ( t.Territory_Inactive__c )
            { 
                options.add(new SelectOption(t.Id, '[INACTIVE] ' + t.Name));
            }
            else
            {
                options.add(new SelectOption(t.Id, t.Name));
            }
        }
        options.sort();
        options.add(new SelectOption('','--None--'));

        return options;
    }

    public Opportunity getThisOpp()
    {
        if ( thisOpp == null )
        {
            thisOpp = [select id, name, TerritoryId, OwnerId from opportunity where id = :paramOppId];
        }
        return thisOpp;
    }

    public PageReference save()
    {
        Pagereference pageref = new ApexPages.StandardController(thisOpp).view();
//        Pagereference pageref = ApexPages.CurrentPage();
        pageref.setRedirect(true);

        if ( selectedTerritory == '' )
        {
            thisOpp.TerritoryId = null;
        }
        else
        {
            thisOpp.TerritoryId = selectedTerritory;
        }
        upsert thisOpp;

        return pageref;
    }

    public PageReference cancel() {
        Pagereference pageref = new ApexPages.StandardController(thisOpp).view();
        pageref.setRedirect(true);

        return pageref;
    }
}