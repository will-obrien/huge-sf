public with sharing class ContactClass {
public Contact con1{get;set;}
public ContactClass(ApexPages.StandardController controller) {
    con1 =(contact)controller.getRecord();
    system.debug('***********'+con1);
}
public PageReference dopop() {
        Account objAcc =[select Id,name,Billingcity,Billingcountry,billingstate,billingpostalcode from Account where Id =:con1.AccountId ];
        con1.Mailingcity=objAcc.billingcity;
        con1.mailingcountry = objAcc.billingcountry;
        con1.mailingpostalcode = objAcc.billingpostalcode;
        con1.mailingstate = objAcc.billingstate;
        return null;
    }
   
}