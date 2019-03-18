public class pkb_css_customizations {
	public String pkbDesignId {get; set;}
    
    public Public_Knowledge_Base_Design__c getMyDesign() {
    	Public_Knowledge_Base_Design__c myDesign = [select Id, Body_Font_Color__c, Body_BG_Color__c, div_body_BG_Color__c, div_body_Border_Color__c, div_right_column_BG_Color__c, div_right_column_Border_Color__c, textarea_default_color__c, h2_section_Border_Color__c, div_narrowSearch_Border_Color__c, select_language_Border_Color__c, ahref_color__c, div_feedbackDialog_Border_Color__c, searchAskInputContainer_Border_Color__c, searchAskInputContainer_shadow_Color__c, action_color__c, div_selectedArticle_Background_Color__c, div_selectedArticle_Border_Color__c, div_article_div_data_Color__c, h2_section_Color__c, knowledgeTOCRendererSection_selected_BG__c, knowledgeTOCRendererSection_selected_FC__c, knowledgeTOCRendererSections_BG_Color__c,knowledgeTOCRendererSection_BG_Color__c, knowledgeTOCRendererSections_color__c, sectionName_selected_BGColor__c, sectionName_selected_td_color__c, sectionName_BG_Color__c, sectionName_td_color__c  from Public_Knowledge_Base_Design__c where id=: pkbDesignId];	   
        return myDesign;
    }
}