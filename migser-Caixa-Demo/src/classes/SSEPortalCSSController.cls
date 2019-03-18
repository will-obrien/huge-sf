public class SSEPortalCSSController {
    public Org_Template__c userTemplate {get;set;}
    public String myTest {get;set;}
    public String userId {get;set;}
    public List<String> myList {Get;set;}
    public List<String> myParams {Get;set;}
    public String nId {get;set;}
    
    public SSEPortalCSSController(){
        if (userId == null || userId == '') userId = UserInfo.getUserId();
        myTest = String.valueOf(ApexPages.CurrentPage().getAnchor());
        myParams = ApexPages.CurrentPage().getHeaders().values();
        //User theUser = [SELECT Branding_Template__c FROM User WHERE id = :userId];
        //replacing the above query with the modified query - Darshil
        String templateId = ApexPages.currentPage().getParameters().get('tId');
        System.debug(templateId );
        if(templateId == null){
            retrieveTemplate_UserId(userId);
        } else{
            //this is for Web2Lead Scenarios where we have the template that needs to be pulled in
            retrieveTemplate_userId(templateId);
        }
        
    }
    
    public PageReference MyAction() {
        if (userId == null || userId == '') userId = ApexPages.CurrentPage().getParameters().get('userId');
        if (userId == null || userId == '') userId = UserInfo.getUserId();
        retrieveTemplate_UserId(userId);
        return null; 
    }
    

    public void retrieveTemplate_UserId(String userId){
        String Branding_Template_Id = '';
        User theUser = [Select ProfileId from User where id = :userId];
        if(Network.getNetworkId() != null){
            nId = '' + Network.getNetworkId() + '%';
        } else{
            //only in test scenario
            nId = [Select Id from Network where Name Like '%Customer%'].Id;
        }
        System.debug(theUser.ProfileId +'||'+ nId);
        Template_Map__c uTemplate = new Template_Map__c();
        for(Template_Map__c t : [Select Demo_Template__c from Template_Map__c where Profile__c = :theUser.ProfileId and Community__c Like :nId Limit 1]){
          uTemplate = t;   
        }
        System.debug(uTemplate.Demo_Template__c);
        retrieveTemplate_tId(uTemplate.Demo_Template__c);
        /*User theUser = [SELECT ProfileId, Branding_Template__c FROM User WHERE id = :userId];
        System.debug('In the CSS Controller');
        System.debug(Network.getNetworkId());
        System.debug(theUser.ProfileId);*/
    }
    
    public void retrieveTemplate_tId(String templateId){
        List<Org_Template__c> templateList = [SELECT Image_Background_Image__c, Image_Background_Position__c, Image_Background_Repeat__c, Position_Footer__c, Back_Background_G_B__c,Back_Background_G_T__c,Back_Body_G_B__c,Back_Body_G_T__c,Back_Button_G_B__c,Back_Button_G_T__c,Back_Button_H_G_B__c,Back_Button_H_G_T__c,Back_Footer_G_B__c,Back_Footer_G_T__c,Back_Header_B_G_B__c,Back_Header_B_G_T__c,Back_Header_Mid_G_B__c,Back_Header_Mid_G_T__c,Back_Header_T_G_B__c,Back_Header_T_G_T__c,Back_Navigation_Menu_H__c,Back_Navigation_Menu__c,Back_Page_Block_G_B__c,Back_Page_Block_G_T__c,Back_Page_Block_Header_G_B__c,Back_Page_Block_Header_G_T__c,Back_Page_Block_Table_Even__c,Back_Page_Block_Table_Odd__c,Back_Side_Button_G_B__c,Back_Side_Button_G_T__c,Back_Side_Button_H_G_B__c,Back_Side_Button_H_G_T__c,Back_Side_G_B__c,Back_Side_G_T__c,Back_Side_Module_G_B__c,Back_Side_Module_G_T__c,Back_Side_Module_Header_G_B__c,Back_Side_Module_Header_G_T__c,Back_Side__c,Back_Tab_A_G_B__c,Back_Tab_A_G_T__c,Back_Tab_G_B__c,Back_Tab_G_T__c,Back_Tab_H_G_B__c,Back_Tab_H_G_T__c,Component_Approvals__c,Component_Articles__c,Component_Cases__c,Component_Charts__c,Component_Entitlements__c,Component_Ideas__c,Component_Image__c,Component_Leads__c,Component_Products__c,Component_Solutions__c,ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,Font_Colour_Button_H__c,Font_Colour_Button__c,Font_Colour_Main__c,Font_Colour_Navigation_Menu_H__c,Font_Colour_Navigation_Menu__c,Font_Colour_Page_Title__c,Font_Colour_Secondary_Title__c,Font_Colour_Side_Button_H__c,Font_Colour_Side_Button__c,Font_Colour_Side_Header__c,Font_Colour_Small_Information__c,Font_Colour_Tab_A__c,Font_Colour_Tab_H__c,Font_Colour_Tab__c,Font_Decoration_Button_H__c,Font_Decoration_Button__c,Font_Decoration_Main__c,Font_Decoration_Navigation_Menu_H__c,Font_Decoration_Navigation_Menu__c,Font_Decoration_Page_Title__c,Font_Decoration_Secondary_Title__c,Font_Decoration_Side_Button_H__c,Font_Decoration_Side_Button__c,Font_Decoration_Side_Header__c,Font_Decoration_Small_Information__c,Font_Decoration_Tab_A__c,Font_Decoration_Tab_H__c,Font_Decoration_Tab__c,Font_Size_Button_H__c,Font_Size_Button__c,Font_Size_Main__c,Font_Size_Navigation_Menu_H__c,Font_Size_Navigation_Menu__c,Font_Size_Page_Title__c,Font_Size_Secondary_Title__c,Font_Size_Side_Button_H__c,Font_Size_Side_Button__c,Font_Size_Side_Header__c,Font_Size_Small_Information__c,Font_Size_Tab_A__c,Font_Size_Tab_H__c,Font_Size_Tab__c,Font_Transform_Button_H__c,Font_Transform_Button__c,Font_Transform_Main__c,Font_Transform_Navigation_Menu_H__c,Font_Transform_Navigation_Menu__c,Font_Transform_Page_Title__c,Font_Transform_Secondary_Title__c,Font_Transform_Side_Button_H__c,Font_Transform_Side_Button__c,Font_Transform_Side_Header__c,Font_Transform_Small_Information__c,Font_Transform_Tab_A__c,Font_Transform_Tab_H__c,Font_Transform_Tab__c,Font_Weight_Button_H__c,Font_Weight_Button__c,Font_Weight_Main__c,Font_Weight_Navigation_Menu_H__c,Font_Weight_Navigation_Menu__c,Font_Weight_Page_Title__c,Font_Weight_Secondary_Title__c,Font_Weight_Side_Button_H__c,Font_Weight_Side_Button__c,Font_Weight_Side_Header__c,Font_Weight_Small_Information__c,Font_Weight_Tab_A__c,Font_Weight_Tab_H__c,Font_Weight_Tab__c,Id,Image_Background__c,Image_Body__c,Image_Button_H__c,Image_Button__c,Image_Footer__c,Image_Logo__c,Image_Page_Block_Header__c,Image_Slide1__c,Image_Slide2__c,Image_Slide3__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,Position_Page__c,Position_Sidebar__c,Position_Slider__c,Position_Tabs__c,Radius_Button__c,Radius_Page_Block__c,Radius_Side_Button__c,Radius_Side_Module__c,Radius_Side__c,Radius_Tab__c,Shadow_Body__c,Shadow_Header__c,Shadow_Page_Block__c,Shadow_Side_Module__c,Shadow_Side__c FROM Org_Template__c WHERE Id = :templateId];
        if(templateList.size() > 0) userTemplate = templateList[0];
        else userTemplate = null;
    }
    //Test Method
    public static testmethod void testSSEPortalCSSController() {
        User u = [Select Id from User where Name like '%Darshil%'];
        System.runAs(u) {
            SSEPortalCSSController controller = new SSEPortalCSSController();
            controller.myAction();
        }
    }
}