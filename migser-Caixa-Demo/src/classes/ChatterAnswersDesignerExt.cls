public with sharing class ChatterAnswersDesignerExt {

    private final Chatter_Answers_Design__c design;
    
    public ChatterAnswersDesignerExt(ApexPages.StandardController controller) {
        design = (Chatter_Answers_Design__c) controller.getRecord();
    }

    @remoteAction 
    public static void saveUpdates(String designId, String Background_Color, String Buttons_Color, String Buttons_Text_Color, String Comments_Background_Color, String Criteria_Highlight_Color, String Criteria_Highlight_Text_Color, String Customer_Support_Tag_Text_Color, String Left_Content_Text_Color,String Links_Color, String Show_More_Background_Color, String Topics_Highlight_Color, String Topics_Highlight_Text_Color) {
        Chatter_Answers_Design__c design = [SELECT Background_Color__c,Buttons_Color__c,Buttons_Text_Color__c,Comments_Background_Color__c,Criteria_Highlight_Color__c,Criteria_Highlight_Text_Color__c,Customer_Support_Tag_Text_Color__c,Left_Content_Text_Color__c,Links_Color__c,Show_More_Background_Color__c,Topics_Highlight_Color__c,Topics_Highlight_Text_Color__c FROM Chatter_Answers_Design__c where id=: designId];
        design.Background_Color__c = Background_Color;        
        design.Buttons_Color__c = Buttons_Color;
        design.Buttons_Text_Color__c = Buttons_Text_Color;
        design.Comments_Background_Color__c = Comments_Background_Color;
        design.Criteria_Highlight_Color__c = Criteria_Highlight_Color;
        design.Criteria_Highlight_Text_Color__c = Criteria_Highlight_Text_Color;        
        design.Customer_Support_Tag_Text_Color__c = Customer_Support_Tag_Text_Color;
        design.Left_Content_Text_Color__c = Left_Content_Text_Color;
        design.Links_Color__c = Links_Color;
        design.Show_More_Background_Color__c = Show_More_Background_Color;
        design.Topics_Highlight_Color__c = Topics_Highlight_Color;
        design.Topics_Highlight_Text_Color__c = Topics_Highlight_Text_Color;
        
        update design;
    }
    
    public static testMethod void testExtension(){
        PageReference pageRef = Page.ChatterAnswersDesigner;
        Test.setCurrentPage(pageRef);
        
        Chatter_Answers_Design__c newDesign = new Chatter_Answers_Design__c();
        newDesign.Background_Color__c = '#000000';        
        newDesign.Buttons_Color__c = '#000000';
        newDesign.Buttons_Text_Color__c = '#000000';
        newDesign.Comments_Background_Color__c = '#000000';
        newDesign.Criteria_Highlight_Color__c = '#000000';
        newDesign.Criteria_Highlight_Text_Color__c = '#000000';        
        newDesign.Customer_Support_Tag_Text_Color__c = '#000000';
        newDesign.Left_Content_Text_Color__c = '#000000';
        newDesign.Links_Color__c = '#000000';
        newDesign.Show_More_Background_Color__c = '#000000';
        newDesign.Topics_Highlight_Color__c = '#000000';
        newDesign.Topics_Highlight_Text_Color__c = '#000000';
        
        insert newDesign;
        
        ChatterAnswersDesignerExt.saveUpdates(newDesign.Id, '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff');
        List<Chatter_Answers_Design__c> designs = [SELECT Background_Color__c,Buttons_Color__c,Buttons_Text_Color__c,Comments_Background_Color__c,Criteria_Highlight_Color__c,Criteria_Highlight_Text_Color__c,Customer_Support_Tag_Text_Color__c,Left_Content_Text_Color__c,Links_Color__c,Show_More_Background_Color__c,Topics_Highlight_Color__c,Topics_Highlight_Text_Color__c FROM Chatter_Answers_Design__c where id= :newDesign.Id];
        System.assertEquals(designs.size(), 1);
        System.assertEquals(designs[0].Background_Color__c, '#ffffff');
    }
    
}