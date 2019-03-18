@isTest
private class DashboardTemplatesControllerTest {

	@istest
	static void testDashboardTemplatesController() {
        test.startTest();
        
        PageReference pageRef = Page.DashboardTemplates;
        Test.setCurrentPageReference(pageRef);     
        System.currentPageReference().getParameters().put('json', '{"widgets": {"Logo_box": {"params": {"borderColor": "rgba(0, 0, 0, 0)","backgroundColor": "rgba(132, 132, 132, 0.39)"},"type": "BoxWidget","pos": {"w": 130,"zIndex": 17,"y": 10,"h": 80,"x": 60}}}}');
        System.currentPageReference().getParameters().put('name', 'Test');   
        
        DashboardTemplatesController t = new DashboardTemplatesController();
        t.startNew();
        t.createDashboard();
        t.getSessionIdFromLensApex();
        t.getFolders('');
        System.assert(t.getDashboardId().equals('0FKB00000000000000'));

        System.currentPageReference().getParameters().put('colorMap', '{"rgba(132, 132, 132, 0.39)":"rgb(0, 0, 0)"}');   
        t.updateColor();
        
        String strWidgetJSON = '{"params": {"borderColor": "rgba(0, 0, 0, 0)","backgroundColor": "rgba(132, 132, 132, 0.39)"}}';
        Map<String, Object> widgetJSON = (Map<String, Object>)JSON.deserializeUntyped(strWidgetJSON);
        Map<String, Object> colorMap = new Map<String, Object> { 'rgba(0, 0, 0, 0)' => 'rgb(255, 255, 255)' };
        t.processWidgetColor('Logo_box', widgetJSON, 'borderColor', colorMap, new Map<String, Object> {} );        
        
        t.setDashboardLogoId('000000');
        t.refreshDashboardLogo();
        System.assert(t.getDashboardLogoId().equals('000000'));          
        
        t.deleteDashboard();        
        System.assert(t.getDashboardId().equals(''));        

        Test.stopTest();
	}   
}