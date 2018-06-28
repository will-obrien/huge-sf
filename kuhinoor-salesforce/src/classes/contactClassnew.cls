Public class contactClassnew{
    public contact con1{get;set;}
    Public contactClassnew(){
        con1 = new Contact();
    }
    Public PageReference fill(){
       
        Account objAcc =[select Id,name,Billingcity,Billingcountry,billingstate,billingpostalcode from Account where Id =:con1.AccountId ];
        con1.Mailingcity=objAcc.billingcity;
        con1.mailingcountry = objAcc.billingcountry;
        con1.mailingpostalcode = objAcc.billingpostalcode;
        con1.mailingstate = objAcc.billingstate;
    return null;
    }
}