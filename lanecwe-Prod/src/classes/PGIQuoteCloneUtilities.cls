public with sharing class PGIQuoteCloneUtilities 
{
  public static Quote getCreatableFieldsOfQuote(String cloneQuoteID)
  {
    String quoteQuery = '';
    Map<String, Schema.SObjectField> quoteFields = Schema.SObjectType.Quote.Fields.getMap();
    for(String fld: quoteFields.keySet())
    {
      if(quoteQuery.length() != 0)
      {
        quoteQuery += ',';
      }
      quoteQuery += fld;
    }
    String queryString = 'SELECT ' + quoteQuery + ' FROM Quote where Id = \'' + cloneQuoteID + '\'';
    Quote oldQuote = Database.query(queryString);
    Quote clonedQuote1 = oldQuote.clone(false, true);
    clonedQuote1.Name = oldQuote.Name + ' - Cloned';
    clonedQuote1.InternalSignature__c=null ;
    clonedQuote1.CustomerSignature__c=null;
    clonedQuote1.Internal_Signature_Type__c='';
    clonedQuote1.Customer_Signature_Type__c='';
    clonedQuote1.iscloned__c=true;
    clonedQuote1.ServiceCommencementDate__c=null;
    clonedQuote1.ParentDeal__c=cloneQuoteID;
    clonedQuote1.ParentQuoteName__c=oldQuote.name;
    clonedQuote1.Parent_Contract_Number__c= oldQuote.Contrct_Number__c;
    list<quote>temp=[select id from Quote where ParentDeal__c=:oldQuote.id];
    if(temp!=null && temp.size()>0)
    {
    clonedQuote1.Amendment_Number__c=temp.size()+1;
  
    }
    else{
    clonedQuote1.Amendment_Number__c=01;
   
    }
    list<quote>opp=[select id from Quote where opportunityid=:oldQuote.opportunityid];
     if(opp!=null && opp.size()>0)
     {
     clonedQuote1.Contrct_Number__c=opp.size()+1 ;
          
     }
     else
     {
     clonedQuote1.Contrct_Number__c=01;
        }
    clonedQuote1.Account__c = oldQuote.Account__c ;
    clonedQuote1.ContactId = oldQuote.ContactId ;
    clonedQuote1.Status = 'Quote- In Progress';
    insert clonedQuote1;
    return clonedQuote1;
  }
  
    public static string getCreatableFieldsSOQL(String cloneQuoteID, String sobj, String prodType){
         String sObjFieldQuery = '';
         String queryString = '';
         try{
             Map<String, Schema.SObjectField> mapOfsobjectFields = Schema.getGlobalDescribe().get(sobj.toLowerCase()).getDescribe().Fields.getMap();
        for(String fld: mapOfsobjectFields.keySet())
        {
          if(sObjFieldQuery.length() != 0)
          {
            sObjFieldQuery += ',';
          }
            sObjFieldQuery += fld;
        }
           if(sobj.equalsIgnoreCase('QuoteLineItem'))
        {
          if(prodType.equalsIgnoreCase('Service'))
          {
            queryString = 'SELECT ' + sObjFieldQuery + ' FROM QuoteLineItem where QuoteId = \'' +
                     cloneQuoteID + '\' AND  Product__r.ProductType__c= \'' + 'service'+'\' order by Product__r.Name';
            return queryString;
          }
          else if(prodType.equalsIgnoreCase('Addon'))
          {
          queryString = 'SELECT ' + sObjFieldQuery + ' FROM QuoteLineItem where QuoteId = \'' +
                     cloneQuoteID + '\' AND  Product__r.ProductType__c!= \'' + 'service'+'\'';
                     
            return queryString ;
          }
        
        }
      
      return queryString;    
         }catch(Exception e){
           system.debug('exception'+ e);
           return queryString;
         }
         
    }      
}