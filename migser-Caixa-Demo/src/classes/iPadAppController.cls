public with sharing class iPadAppController {

    //private String iPadAppName = 'Standard App';

    public iPadAppMaker__c instance { get; set; }
    
    
    public iPadAppController(ApexPages.StandardController controller) {
        String appId = controller.getId();
        instance = [Select i.app_icon__c, i.sidebar_position__c, i.sidebar_button_5__c, i.sidebar_button_4__c, i.sidebar_button_3__c, i.sidebar_button_2__c, i.sidebar_button_1__c, i.sidebar_bg_color__c, i.logo_url__c, i.hd_text_color__c, i.hd_bg_color_start__c, i.hd_bg_color_end__c, i.content_bg_color__c, i.content_5__c, i.content_4__c, i.content_3__c, i.content_2__c, i.content_1__c,i.sub_content_5__c, i.sub_content_4__c, i.sub_content_3__c, i.sub_content_2__c, i.sub_content_1__c, i.youtube_width__c, i.youtube_url__c, i.youtube_top__c, i.youtube_left__c, i.youtube_height__c, i.youtube_enabled__c, i.youtube_tab_number__c, i.Name, i.Id From iPadAppMaker__c i Where i.Id = :AppId];
    }
    
    public iPadAppMaker__c getAppInstance(){
        return instance;
    }
}