public with sharing class Milestone1_Constants {
    
    static public String XML_VERSION = '1.0';
    static public String XML_EXPORT_VERSION_VAL = '1.0';
    static public String XML_EXPORT_VERSION = 'exportVersion';
    static public String XML_EXPORT = 'export';
    static public String XML_META = 'meta';
    static public String XML_ID = 'id';
    static public String XML_NAME = 'name';
    static public String XML_EXPORT_PACKAGE = 'exportPackage';
    static public String XML_EXPORT_PACKAGE_VAL = 'Milestone1_Project_Export';
    static public String XML_EXPORT_AUTHOR = 'exportAuthor';
    static public String XML_EXPORT_AUTHOR_EMAIL = 'exportAuthorEmail';
    static public String XML_EXPORT_ORG = 'exportOrganization';
    static public String XML_EXPORT_DATE = 'exportCreateDate';
    static public String OBJ_NAME_PROJECT = 'Milestone1_Project__c';
    static public String OBJ_NAME_MILESTONE = 'Milestone1_Milestone__c';
    static public String OBJ_NAME_SUB_MILESTONE = 'SubMilestone1_Milestone__c';
    static public String OBJ_NAME_LOG = 'Milestone1_Log__c';
    static public String OBJ_NAME_TASK = 'Milestone1_Task__c';
    static public String OJB_NAME_EXPENSE = 'Milestone1_Expense__c';
    static public String OBJ_NAME_TIME = 'Milestone1_Time__c';
    
    
    static public List<String> XML_OBJECT_PROCESS_ORDER = new List<String>{OBJ_NAME_MILESTONE,OBJ_NAME_LOG};
}