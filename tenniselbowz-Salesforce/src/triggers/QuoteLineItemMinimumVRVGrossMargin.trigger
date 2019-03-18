trigger QuoteLineItemMinimumVRVGrossMargin on QuoteLineItem (after delete, after insert, after update) {
Set<Id> QuoteIds = new Set<Id>();  //Limit the size of list by using Sets which do not contain duplicate elements(A set is an unordered collection of elements that do not contain any duplicates.)
    
    //When adding new QuoteLineItems or updating existing QuoteLineItems
  if(trigger.isInsert || trigger.isUpdate){
    for(QuoteLineItem Ql : trigger.new){	//Iterates Over New Versions of QuoteLineItems as Trigger.New returns a list of the new versions of the sObject records.
      QuoteIds.add(Ql.Quoteid);				//Each QuoteLineItem will have an QuoteID, which will be added to the set and if QuoteID already added before, then it will not create a duplicate
    }
  }

  //When deleting QuoteLineItems
  if(trigger.isDelete){
    for(QuoteLineItem Ql : trigger.old){	//Returns a list of the old versions of the sObject records.
      QuoteIds.add(Ql.Quoteid);
    }
  }

    Map<Id,Quote> map_Quotes = new Map<Id,Quote>	//A map is a collection of key-value pairs where each unique key maps to a single value.
    (   [   SELECT  Id,Minimum_VRV_GM__c				//Quote ID will be Unique ID in Map and Gross_Margin__c is the value in Map.
            FROM    Quote
            WHERE   Id IN :QuoteIds
        ]
    );

    for ( AggregateResult result :					//This object contains the results returned by a query() if the query contains an aggregate function, such as MAX(). AggregateResult is an sObject, but unlike other sObject objects such as Contact, it is read-only and it is only used for query results.
        [   SELECT  Min(Equipment_Gross_Margin__c) minmargin, QuoteId			//Used Min aggregate function to find the minimum Equipment_Gross_Margin__c
            FROM    QuoteLineItem
            WHERE   (Product_Product_Category__c LIKE '%VRV%') AND(QuoteID IN :QuoteIds) 
            GROUP BY QuoteId
        ]
        )
    {
        map_Quotes.get( (Id) result.get( 'QuoteId' ) ).Minimum_VRV_GM__c = (Decimal) result.get( 'minmargin' );
    }

    update map_Quotes.values();
}