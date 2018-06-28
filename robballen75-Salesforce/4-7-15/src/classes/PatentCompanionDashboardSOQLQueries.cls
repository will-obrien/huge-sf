global with sharing class PatentCompanionDashboardSOQLQueries{
     
    @RemoteAction   
    global static contract[] loadContractsAndUserCounts() {
    return [select name,Patent_Companion_Users__c from contract where product__c = 'Patent Companion' and patent_companion_users__c != null and (status = 'active' or status = 'Up For Renewal') and account.name != 'Microsystems'];
     }   
 @RemoteAction
 global static AggregateResult[] loadScansPerDayPast2Weeks() {
 return [select count(Id) count1 , day_only(convertTimezone(scan_time__c)) res2  from patentScans__C where scan_time__c = LAST_N_DAYS:14 and contact__r.account.name != 'Microsystems'  group by day_only(convertTimezone(scan_time__c)) order by day_only(convertTimezone(scan_time__c)) ];
 } 
     
 //query for scans by month
 @RemoteAction   
  global static AggregateResult[] loadScansByMonthPastYear() {
        return [select count(id) counts, calendar_month(convertTimezone(scan_time__c)) month, calendar_year(convertTimezone(scan_time__c)) from patentScans__C where scan_time__c = LAST_N_DAYS:365 and contact__r.account.name != 'Microsystems' group by calendar_month(convertTimezone(scan_time__c)), CALENDAR_YEAR(convertTimezone(Scan_Time__c)) order by CALENDAR_YEAR(convertTimezone(Scan_Time__c)), calendar_month(convertTimezone(scan_time__c)) asc ];
    }   
 //scans by contact
 @RemoteAction   
  global static AggregateResult[] loadScansByUser() {
        return [select count(id) counts, contact__r.name cname from patentscans__c where contact__r.account.name != 'Microsystems' group by contact__r.name order by count(id) desc];
    }   
 
  //scans by Account
 @RemoteAction   
  global static AggregateResult[] loadScansByAccount() {
        return [select count(id) counts, contact__r.account.name aname from patentscans__c where contact__r.account.name != 'Microsystems' group by contact__r.account.name order by count(id) desc];
    } 
 
 //total number of scans
 @RemoteAction   
global static AggregateResult[] loadTotalScansAllTime() {
        return [select count(Id) howManyScans from patentscans__c where contact__r.account.name != 'Microsystems'];
    }   
 //last 60 days, grouped by contact
 @RemoteAction   
global static AggregateResult[] loadScansByUserPast60Days() {
        return [select count(id), day_only(convertTimezone(scan_time__c)), contact__r.name from patentScans__C where scan_time__c = LAST_N_DAYS:60 and contact__r.account.name != 'Microsystems' group by day_only(convertTimezone(scan_time__c)), contact__r.name];
    }   

 //last 60 days, grouped by account
 @RemoteAction   
global static AggregateResult[] loadScansByAccountPast60Days() {
        return [select count(id) counts, day_only(convertTimezone(scan_time__c)) scanDay, contact__r.account.name accountName from patentScans__C where scan_time__c = LAST_N_DAYS:60 and contact__r.account.name != 'Microsystems' group by day_only(convertTimezone(scan_time__c)), contact__r.account.name];
    }  

//active evals with number of scans, and expiration date
@RemoteAction   
global static contract[] loadScanDetailforAcviveEvaluations() {
        return [select enddate, contractindividual__r.Name, contractindividual__r.patent_companion_scans_to_date__c, contractindividual__r.patent_companion_last_scan__c from contract where contract_type__c = 'Evaluation' and (status='Active' or status = 'Up For Renewal') and Product__c = 'Patent Companion' and account.name != 'Microsystems' order by enddate asc];
    }   

//active contracts that started as evals, with number of scans and revenue to date, and expiration date
@RemoteAction   
global static contract[] loadContractDetailActiveContracts() {
        return [select enddate, ContractIndividual__r.Name, contractindividual__r.patent_companion_scans_to_date__c, contractindividual__r.patent_companion_last_scan__c, online_subscription_revenue_to_date__c, Evaluation_End_Date__c from contract where (contract_type__c = 'Agreement (Initial)' or contract_type__c = 'Renewal') and (status='Active' or status = 'Up For Renewal') and Product__c = 'Patent Companion' and account.name != 'Microsystems' and contractIndividual__r.name != null order by enddate asc];
     
    }   

//sum total number of different issues found
@RemoteAction   
global static AggregateResult[] loadTotalNumberOfIssuesFound() {
        return [select sum(Unsupported_Terms_Count__c) unsupported, sum(SimilarSpellingCount__c) spelling, sum(Limiting_Language_Count__c) limiting, sum(Element_References_Count__c) references, sum(Antecedent_Basis_Count__c) basis from patentscans__c where contact__r.account.name != 'Microsystems'];
    }   

  

 //global static contract[] loadContracts() {
  //      return [];
   // }   

 
}