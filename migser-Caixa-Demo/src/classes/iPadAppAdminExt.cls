public with sharing class iPadAppAdminExt {

    public List<iPadAppMaker__c> apps{get; set;}
    public List<SelectOption> appsList{get; set;}
    
    public iPadAppMaker__c instance{get; set;}
    
    public String currentAppId{get; set;}
    
    public String fileUrl_logo{get; set;}
    
    public String fileUrl_icon{get; set;}
    
    public String fileUrl_11{get; set;}
    public String fileUrl_12{get; set;}
    public String fileUrl_13{get; set;}
    public String fileUrl_21{get; set;}
    public String fileUrl_22{get; set;}
    public String fileUrl_23{get; set;}
    public String fileUrl_31{get; set;}
    public String fileUrl_32{get; set;}
    public String fileUrl_33{get; set;}
    public String fileUrl_41{get; set;}
    public String fileUrl_42{get; set;}
    public String fileUrl_43{get; set;}
    public String fileUrl_51{get; set;}
    public String fileUrl_52{get; set;}
    public String fileUrl_53{get; set;}
    
    public String header_color_start{get; set;}
    public String header_color_end{get; set;}

    public String sidebar_bg_color{get; set;}
    public String content_bg_color{get; set;}
        
    public iPadAppAdminExt(ApexPages.StandardController controller) {
        apps = [SELECT Id, Name FROM iPadAppMaker__c];
        appsList = new List<SelectOption>();
        for(iPadAppMaker__c i : apps){
            appsList.add(new SelectOption(i.Id, i.Name));
        }
        
        
        instance = [Select i.app_icon__c, i.sidebar_position__c, i.sidebar_button_5__c, i.sidebar_button_4__c, i.sidebar_button_3__c, i.sidebar_button_2__c, i.sidebar_button_1__c, i.sidebar_bg_color__c, i.logo_url__c, i.hd_text_color__c, i.hd_bg_color_start__c, i.hd_bg_color_end__c, i.content_bg_color__c, i.content_5__c, i.content_4__c, i.content_3__c, i.content_2__c, i.content_1__c, i.sub_content_1__c, i.sub_content_2__c, i.sub_content_3__c, i.sub_content_4__c, i.sub_content_5__c, i.youtube_width__c, i.youtube_url__c, i.youtube_top__c, i.youtube_left__c, i.youtube_height__c, i.youtube_enabled__c, i.youtube_tab_number__c, i.SystemModstamp, i.OwnerId, i.Name, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Id, i.CreatedDate, i.CreatedById, i.ConnectionSentId, i.ConnectionReceivedId From iPadAppMaker__c i where i.id = :controller.getId()];
        
        currentAppId = instance.Id;
        fileUrl_logo = instance.logo_url__c;
        
        fileUrl_icon = instance.app_icon__c;
        
        header_color_start = instance.hd_bg_color_start__c;
        header_color_end = instance.hd_bg_color_end__c;
        
        sidebar_bg_color = instance.sidebar_bg_color__c;
        content_bg_color = instance.content_bg_color__c;
        
        fileUrl_11 = instance.sidebar_button_1__c;
        fileUrl_12 = instance.content_1__c;
        fileUrl_13 = instance.sub_content_1__c;
        fileUrl_21 = instance.sidebar_button_2__c;
        fileUrl_22 = instance.content_2__c;
        fileUrl_23 = instance.sub_content_2__c;
        fileUrl_31 = instance.sidebar_button_3__c;
        fileUrl_32 = instance.content_3__c;
        fileUrl_33 = instance.sub_content_3__c;
        fileUrl_41 = instance.sidebar_button_4__c;
        fileUrl_42 = instance.content_4__c;
        fileUrl_43 = instance.sub_content_4__c;
        fileUrl_51 = instance.sidebar_button_5__c;
        fileUrl_52 = instance.content_5__c;
        fileUrl_53 = instance.sub_content_5__c;
                
    }
    
    public PageReference goToTheApp(){
        return new PageReference('/apex/iPadApp?id=' + currentAppId);
    }
    
    public PageReference switchAppAdmin(){
        PageReference page = new PageReference('/apex/iPadAppAdmin?id=' + currentAppId);
        page.setRedirect(true);
        return page;
    }
    
    public PageReference saveYoutubeConfig(){
    	try {
    		upsert instance;
    	} catch(DMLException e) {
    		
    	}
    	return null;
    }

}