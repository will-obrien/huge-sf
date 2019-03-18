/*
* This class is responsible for creating data for the other test classes 
* Author: Shrawan Raina
* CHANGE HISTORY
*================================================================ 
* 07/02/2014        Shrawan Raina       Created
  07/24/2014        Shrawan Raina       Modified 
*================================================================
*/
public with sharing class TestHelper {
    public static User getStandardUser(boolean create){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@va.gov.qa', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='standarduser@va.gov.qa'); 
        if(create)
            insert u;   
        return u;
    }
    
    public static Contract_Funding_Sources__c getCFS(boolean create, Integer i){
        Project_Funding_Sources__c pfsObj = getPFS(create,i);
        Contract_Funding_Sources__c cfsObj = new Contract_Funding_Sources__c(Project_Funding_Source__c = pfsObj.Id, 
                                                                            Contract__c = getContracts(create,i,pfsObj).Id, Amount__c = 15.00 + i);
        if(create){
            insert cfsObj;
        }
        return cfsObj;
    }
    
    public static Contracts__c getContracts(boolean create, Integer i, Project_Funding_Sources__c pfsObj){
        Contracts__c contract = new Contracts__c(Project__c = pfsObj.Project__c);
        if(create){
            insert contract;
        }   
        return contract;
    }
    
    public static Project_Funding_Sources__c getPFS(boolean create, Integer i){
        Project_Funding_Sources__c pfsObj = new Project_Funding_Sources__c( Funding_Stream__c = getFundingStream(create,i).Id, Project__c = getProject(create,i).Id);
        if(create){
            pfsObj.Funding_Type__c='Request';
            pfsObj.Status__c='Approved';
            pfsObj.Amount__c=1000;
            insert pfsObj;
        }   
        return pfsObj;
    }
    
    public static Project__c getProject(boolean create, Integer i){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt'+i, Email='standarduser@va.gov.qa'+i, 
            EmailEncodingKey='UTF-8', LastName='Testing'+i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='standarduser@va.gov.qa'+i);
        if(create){
            insert u;   
        }
        Project__c project = new Project__c(Name = 'Test Project'+i, Business_Office_Sponsor__c = getAccount(create,i).Id, Portfolio_Manager__c = u.Id, Innovation_Coordinator__c = u.Id);
        if(create){
            insert project;
        }   
        return project;
    }
    
    public static Funding_Streams__c getFundingStream(boolean create, Integer i){
        Funding_Streams__c fundingStream = new Funding_Streams__c(Name = 'Test Funding Stream'+i);
        if(create){
            insert fundingStream;
        }   
        return fundingStream;
    }
    
    public static Account getAccount(boolean create,Integer i){
        Account account = new Account(Name = 'Test Account'+i);
        if(create){
            insert account;
        }   
        return account;
    }
    public static Estimate_Planned__c getEstimate(boolean create,Integer i){
        Estimate_Planned__c estimate = new Estimate_Planned__c(Funding_Stream__c = getFundingStream(create,i).Id, Project__c = getProject(create,i).Id);
        if(create){
            estimate.Funding_Direction__c='Request';
            estimate.Status__c='Approved';
            estimate.Cost_Estimate__c=5000;
            estimate.Administration__c='OIT';
            insert estimate;
        }   
        return estimate;
    }
    
        public static Estimate_Planned__c getEstimate1(boolean create,Integer i){
        Estimate_Planned__c estimate = new Estimate_Planned__c(Funding_Stream__c = getFundingStream(create,i).Id, Project__c = getProject(create,i).Id);
        if(create){
            estimate.Funding_Direction__c='Return';
            estimate.Status__c='Approved';
            estimate.Cost_Estimate__c=5000;
            estimate.Administration__c='VBA';
            insert estimate;
        }   
        return estimate;
    }
}