/*
 * This code is fully borrowed from Anythingpath component 1.3 from Shane McLaughlin
*/
@isTest
public class PDEAnythingPathTest {
	@isTest 
    private static void testQuery(){
        string result =  PDEAnythingPath.query('select id from Case where subject = \'your software sucks\'');
    }

    @isTest 
    private static void testUpdate(){
        //public static void updateField(id recordId, string Field, string newValue){
        list<Case> CaseList = [select Id, Status from Case];        
        PDEAnythingPath.updateField(Caselist[0].id, 'Status', 'Closed');
    }


    @isTest
    private static void test1(){
        case c2 = [select id from case where subject = 'your software sucks'];
        system.debug(c2);
        //public static string getCurrentValue(string recordId, string picklistField, string sObjectName){
        string s = PDEAnythingPath.getCurrentValue(c2.Id, 'Status', 'Case');
        system.debug(s);
    }
    
    @isTest
    private static void test2(){
        //    public static void setNewValue(string recordId, string picklistField, string newValue){
        case c2 = [select id from case where subject = 'your software sucks'];
        system.debug(c2);
        
        PDEAnythingPath.setNewValue(c2.Id, 'Status', 'Screwed');
        
    }
    
    @isTest
    private static void testGetPicklistWithId(){
        //    public static map<String, string> getPicklistOptions(string recordId, string picklistField, string sObjectName){
        case c2 = [select id from case where subject = 'your software sucks'];
        system.debug(c2);
        
        map<String, string> output = PDEAnythingPath.getPicklistOptions(c2.Id, 'Status', 'Case');
        system.debug(output);
    }

    @isTest
    private static void testGetPicklistWithoutId(){
        //    public static map<String, string> getPicklistOptions(string recordId, string picklistField, string sObjectName){
        case c2 = [select id from case where subject = 'your software sucks'];
        system.debug(c2);
        
        map<String, string> output = PDEAnythingPath.getPicklistOptions(null, 'Status', 'Case');
        system.debug(output);
    }



    @isTest static void testNonExistentTopic(){
        string topicName = PDEAnythingPath.dynamicTopic('Case', 'Status');
    }

    //runs the code twice so that the "it exists" version gets fired
    @isTest static void testExistingTopic(){
        string topicName = PDEAnythingPath.dynamicTopic('Case', 'Status');
        topicName = PDEAnythingPath.dynamicTopic('Case', 'Status');
    }
    
    @testSetup static void methodName() {
        case c = new case();
        c.status = 'New';
        c.Subject = 'your software sucks';
        insert c;
    }
}