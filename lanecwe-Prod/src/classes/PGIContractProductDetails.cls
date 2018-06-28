/********************************************************************************
Name:  PGIContractProductDetails()
Copyright © 2013  PGI
======================================================
======================================================
Purpose:
-------
Wrapper class to store the product and verbiage details
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India          02/01/2013        Added 
**********************************************************************************************/  
public class PGIContractProductDetails{
    
    public class Verbiage{
        public string prodName {get ;set;}
        public string termsConditions {get;set;}
        public string productId{get;set;}
        public string verbiageId{get;set;}
        public string ContractDocumentGroup{get;set;}
        public string VerbName{get;set;}
        public boolean IsServiceProduct{get;set;}
        public string producttype {get;set;}
        
        public Verbiage(Add_on_FeatureContractTerms__c prodVerb){
            this.productId=prodVerb.Add_on_Feature__c;
            this.verbiageId=prodVerb.Contract_Term__c;
            this.VerbName=prodVerb.Contract_Term__r.Name;
            this.termsConditions=prodVerb.Contract_Term__r.Terms_and_Conditions__c;
            this.prodName= prodVerb.Add_on_Feature__r.Name;
            this.ContractDocumentGroup=prodVerb.Add_on_Feature__r.ContractDocumentGroup__c;
            this.producttype=prodVerb.Add_on_Feature__r.ProductType__c;
            if(string.valueof(prodVerb.Add_on_Feature__r.ProductType__c).equalsIgnoreCase('Service')){
                this.isServiceProduct = true;
            }else{
                this.isServiceProduct = false;
            }
        }
    }
 }