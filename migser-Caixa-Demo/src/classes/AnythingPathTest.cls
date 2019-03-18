@isTest
public class AnythingPathTest {
    
    @isTest
    private static void test1(){
        case c2 = [select id from case where subject = 'your software sucks'];
        system.debug(c2);
        //public static string getCurrentValue(string recordId, string picklistField, string sObjectName){
        string s = AnythingPath.getCurrentValue(c2.Id, 'Status', 'Case');
        system.debug(s);
    }
    
    @isTest
    private static void test2(){
        //    public static void setNewValue(string recordId, string picklistField, string newValue){
        case c2 = [select id from case where subject = 'your software sucks'];
        system.debug(c2);
        
        AnythingPath.setNewValue(c2.Id, 'Status', 'Screwed');
        
    }
    
    @isTest
    private static void test3(){
        //    public static map<String, string> getPicklistOptions(string recordId, string picklistField, string sObjectName){
        case c2 = [select id from case where subject = 'your software sucks'];
        system.debug(c2);
        
        map<String, string> output = AnythingPath.getPicklistOptions(c2.Id, 'Status', 'Case');
        system.debug(output);
    }
    
    @testSetup static void methodName() {
        case c = new case();
        c.status = 'New';
        c.Subject = 'your software sucks';
        insert c;
    }
}