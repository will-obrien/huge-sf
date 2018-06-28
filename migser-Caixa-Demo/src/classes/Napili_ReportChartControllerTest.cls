@IsTest
public class Napili_ReportChartControllerTest {

    @IsTest(SeeAllData=true)
    public static void testGetReportMetaDataForNonScatter(){
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String result = Napili_ReportChartController.getReportMetaData('00O28000005ZPK5', '/test');
        
        Map<String, Object> resultDataMap = (Map<String, Object>)JSON.deserializeUntyped(result);        
        
        String chartType = (String)resultDataMap.get('chartType');
        String summary = (String)resultDataMap.get('summary');
        String grouping = (String)resultDataMap.get('grouping');
        
        System.assert(chartType=='Donut');
        System.assert(summary=='s!Case_Status_Change__c.Status_Time__c');
        System.assert(grouping=='Case_Status_Change__c.Status_Name__c');
        
    }
    
    @IsTest(SeeAllData=true)
    public static void testGetReportMetaDataForScatter(){
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        
        String result = Napili_ReportChartController.getReportMetaData('00O28000005ZPK5', '/test');
        
        Map<String, Object> resultDataMap = (Map<String, Object>)JSON.deserializeUntyped(result);        
        
        String chartType = (String)resultDataMap.get('chartType');
        String summary = (String)resultDataMap.get('summary');
        String grouping = (String)resultDataMap.get('grouping');
        
        System.assert(chartType=='Scatter');
        
    }
    
    
    
}