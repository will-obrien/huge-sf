public class OpportunityView {

    List<Opportunity> oppId;
    @TestVisible List<Opportunity> opportunities;
    List<OpportunityLineItem> oppLineItems;

    @TestVisible List<OpportunityLineItem> getOpportunityLineItems(String opportunityID) {
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        opportunityLineItems = [SELECT Name, Description, OpportunityId, Quantity, ListPrice, PricebookEntryId, Product2Id, ProductCode, ServiceDate, SortOrder, TotalPrice, UnitPrice FROM OpportunityLineItem WHERE OpportunityId=:opportunityID];

        return opportunityLineItems;
    }
    
    @TestVisible String oppListToTable(List<OpportunityLineItem> oppList) {
        String table = '<table id="customTable">'; 

        table += '<tr><th>Name:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.Name + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>Description:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.Description + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>OpportunityId:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.OpportunityId + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>Quantity:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.Quantity + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>ListPrice:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.ListPrice + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>PricebookEntryId:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.PricebookEntryId + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>Product2Id:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.Product2Id + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>ProductCode:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.ProductCode + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>ServiceDate:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.ServiceDate + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>SortOrder:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.SortOrder + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>TotalPrice:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.TotalPrice + '</td>';
        }
        table += '</tr>';
        
        table += '<tr><th>UnitPrice:</th>';
        for(OpportunityLineItem o : oppList) {
                table += '<td>' + o.UnitPrice + '</td>';
        }
        table += '</tr>';
        
        table += '</td></tr></table>';
        return table;
    }

    public String selectedItem {
        get;
        set;
    }

    public String getBuiltTable() {
        String output = ''; 
        integer index = 0;
        for(Opportunity o : opportunities) {
            if(o.Name.equals(selectedItem)) {
                break;
            }
            ++index;
        }

        if(index < opportunities.size()) {
            oppLineItems = getOpportunityLineItems(opportunities[index].Id);
            output = oppListToTable(oppLineItems);
        }
        return output;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        opportunities = [SELECT Name FROM Opportunity WHERE HasOpportunityLineItem=true ORDER BY CreatedDate ASC];

        for(Opportunity o : opportunities) {
            options.add(new SelectOption(o.name,o.name));
        }
        return options;
    }
}