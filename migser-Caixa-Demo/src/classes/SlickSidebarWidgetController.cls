public class SlickSidebarWidgetController{
	public SlickSidebar__c config {set;get;}

    
    public SlickSidebarWidgetController() {
	    config = [SELECT Accordion_Arrow_Colour__c, Show_Customer_Summary__c, Show_Related_Cases__c, Show_Activity_History__c, Show_Nearby_Locations__c,
          Show_Related_Opportunities__c, Show_Generic_Related_List_1__c, Show_Generic_Related_List_2__c, Row_Hover_Colour__c
          FROM SlickSidebar__c LIMIT 1];        
    }
}