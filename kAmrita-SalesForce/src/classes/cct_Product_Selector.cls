public with sharing class cct_Product_Selector extends fflib_SObjectSelector implements cct_iProduct_Selector{
        public static cct_Product_Selector newInstance()
                {
                    return (cct_Product_Selector) cct_Application.Selector.newInstance(Product__c.SObjectType);
                }

            public List<Schema.SObjectField> getSObjectFieldList()
            {
                return new List<Schema.SObjectField> {
                        Product__c.Name,
                        Product__c.SellingCriterion__c,
                        Product__c.Product_Instance__c,
                        Product__c.ScoreCard__c
                    };
            }
        
            public Schema.SObjectType getSObjectType()
            {
                return Product__c.sObjectType;
            }
        
            public List<Product__c> selectByName(String name)
            {
                String query = newQueryFactory(false)
                .assertIsAccessible()
                .selectFields( this.getSObjectFieldList() )
                .setCondition('Name = :name')
                .toSOQL();
        
                return Database.query( query );
            }   
}