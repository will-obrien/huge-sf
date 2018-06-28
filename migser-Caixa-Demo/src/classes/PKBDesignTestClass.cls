@isTest
public class PKBDesignTestClass {
	static testMethod void pkbTestMethod() {
     	Public_Knowledge_Base_Design__c design = new Public_Knowledge_Base_Design__c();
        design.Name = 'Default Test Design';
        design.Body_Font_Color__c = '#FF0000';
        insert design;
        
        //Test The Component Controller
        pkb_css_customizations myCss = new pkb_css_customizations();
        myCss.pkbDesignId = design.Id;
        Public_Knowledge_Base_Design__c myDesign = myCss.getMyDesign();
        System.assertEquals(design.Body_Font_Color__c, myDesign.Body_Font_Color__c);
     
        List<String> colors = new List<String>{'#FF0000','#00FF00','#0000FF'};
            
        PageReference pageRef = Page.PKBDesigner;
		Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(design);
        PKBDesignerExt myPageCon = new PKBDesignerExt(sc);
		myPageCon.goToStepOne();
		myPageCon.goToStepTwo();
        myPageCon.goToStepThree();
        
        PKBDesignerExt.updatePKBArticleDesign(myDesign.Id, colors[0], colors[1], colors[2], colors[0], colors[1], colors[2], colors[0], colors[1], colors[2]);
        
        PKBDesignerExt.updatePKBDesign(myDesign.Id, colors[0], colors[1], colors[2], colors[0], colors[0], colors[0], colors[0], colors[0], colors[0], colors[0], colors[0]); 
        
        myCss = new pkb_css_customizations();
        myCss.pkbDesignId = design.Id;
        myDesign = myCss.getMyDesign();
        System.assertEquals(myDesign.ahref_color__c, colors[0]);
        

            
    }
}