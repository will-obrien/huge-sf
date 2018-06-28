public class cct_Strategies extends Fflib_SObjectDomain implements cct_iStrategy{
    public static  cct_Strategies newInstance(List<Stratergy__c> sObjectList)
    {
        return (cct_Strategies) cct_Application.Domain.newInstance(sObjectList);
    }


    public cct_Strategies(List<Stratergy__c> records) 
    {
        super(records); 
    }
    
    public void setStrategy(fflib_ISObjectUnitOfWork uow,String name,String evaluationCriterion){
        		Stratergy__c stratergy = new Stratergy__c();
                stratergy.name__c = name;
                stratergy.Name = name;
                stratergy.Description__c = evaluationCriterion;
                
               
                uow.registerNew( stratergy );
            
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct(List<SObject> sObjectList)
        {
            return new cct_Strategies(sObjectList);
        }
    }
}