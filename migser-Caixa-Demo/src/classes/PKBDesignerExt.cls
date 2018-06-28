public with sharing class PKBDesignerExt {
    private Public_Knowledge_Base_Design__c design;
    public Integer stepNumber {get; set;}
    
    public PKBDesignerExt(ApexPages.StandardController controller) {
        design = (Public_Knowledge_Base_Design__c) controller.getRecord();
        stepNumber = 1;
    }
    
    @remoteAction
    public static void updatePKBArticleDesign(String pkbDesignId, String knowledgeTOCRendererSection_selected_BG, String knowledgeTOCRendererSection_selected_FC, String knowledgeTOCRendererSections_BG_Color, String knowledgeTOCRendererSection_BG_Color, String knowledgeTOCRendererSections_color, String sectionName_selected_BGColor, String sectionName_selected_td_color, String sectionName_BG_Color, String sectionName_td_color) {
        Public_Knowledge_Base_Design__c myDesign = [select Id from Public_Knowledge_Base_Design__c where id=: pkbDesignId];
        myDesign.knowledgeTOCRendererSection_selected_BG__c = knowledgeTOCRendererSection_selected_BG;
        myDesign.knowledgeTOCRendererSection_selected_FC__c = knowledgeTOCRendererSection_selected_FC;
        myDesign.knowledgeTOCRendererSections_BG_Color__c = knowledgeTOCRendererSections_BG_Color;
        myDesign.knowledgeTOCRendererSection_BG_Color__c = knowledgeTOCRendererSection_BG_Color;
        myDesign.knowledgeTOCRendererSections_color__c = knowledgeTOCRendererSections_color;
        myDesign.sectionName_selected_BGColor__c = sectionName_selected_BGColor;
		myDesign.sectionName_selected_td_color__c = sectionName_selected_td_color;
        myDesign.sectionName_BG_Color__c = sectionName_BG_Color;
        myDesign.sectionName_td_color__c = sectionName_td_color;
        upsert myDesign;
    }
    
    @remoteAction
    public static void updatePKBDesign(String pkbDesignId, String ahrefColor, String bodyBGColor, String div_body_BG_Color, String action_color, String select_language_Border_Color, String searchAskInputContainer_Border_Color, String h2_section_Border_Color, String Body_Font_Color, String div_right_column_BG_Color, String div_article_div_data_Color, String h2_section_Color) {
        Public_Knowledge_Base_Design__c myDesign = [select Id, Body_Font_Color__c, Body_BG_Color__c, div_body_BG_Color__c, div_body_Border_Color__c, div_right_column_BG_Color__c, div_right_column_Border_Color__c, textarea_default_color__c, h2_section_Border_Color__c, div_narrowSearch_Border_Color__c, select_language_Border_Color__c, ahref_color__c, div_article_div_data_Color__c, div_feedbackDialog_Border_Color__c, searchAskInputContainer_Border_Color__c, searchAskInputContainer_shadow_Color__c, action_color__c, div_selectedArticle_Background_Color__c, div_selectedArticle_Border_Color__c  from Public_Knowledge_Base_Design__c where id=: pkbDesignId];
        myDesign.ahref_color__c = ahrefColor;
        myDesign.Body_BG_Color__c = bodyBGColor;
        myDesign.div_body_BG_Color__c = div_body_BG_Color;
        myDesign.action_color__c = action_color;
        myDesign.select_language_Border_Color__c = select_language_Border_Color;
        myDesign.searchAskInputContainer_Border_Color__c = searchAskInputContainer_Border_Color;
        //Shadow can go to the same color for now - this may be separated out later       
        myDesign.searchAskInputContainer_shadow_Color__c = searchAskInputContainer_Border_Color;
        myDesign.h2_section_Border_Color__c = h2_section_Border_Color;
        myDesign.Body_Font_Color__c = Body_Font_Color;
        myDesign.div_right_column_BG_Color__c = div_right_column_BG_Color;
        myDesign.div_article_div_data_Color__c = div_article_div_data_Color;
        myDesign.h2_section_Color__c = h2_section_Color;
        upsert myDesign;
    }
    
    public PageReference goToStepTwo() {
        stepNumber = 2;
        return null;
    }
    
    public PageReference goToStepOne() {
     	stepNumber = 1;
        return null;
    }
    
    public PageReference goToStepThree() {
     	stepNumber = 3;
        return null;
    }

}