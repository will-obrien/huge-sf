public class cct_Application {
// Configure the UnitOfWorkFactory for this Application
    public static List<SobjectType> unitOfWorkTypes = new List<SObjectType> { 
        Product__c.SObjectType, 
        Stratergy__c.SObjectType,
        EvaluationCriterion__c.SObjectType
        
    }; 
// Configure the DomainFactory for this Application
    public static Map<SObjectType, Type> domainTypesMap = new Map<SObjectType, Type> {
        Product__c.SObjectType => cct_Products.Constructor.class,
        Stratergy__c.SObjectType => cct_Evaluate.Constructor.class
    };
    
// Configure the SelectorFactory for this Application
    public static Map<SObjectType, Type> selectorTypeMap = new Map<SObjectType, Type>{
        Product__c.SObjectType => cct_Product_Selector.class,
        Stratergy__c.SObjectType => cct_Strategy_Selector.class,
        EvaluationCriterion__c.SObjectType => cct_Evaluate_Selector.class
    };

// Configure the ServiceFactory for this Application
    public static Map<Type,Type> serviceTypesMap =  new Map<Type, Type> {
        cct_iStrategy_Service.class => cct_Strategy_ServiceImpl.class,
        cct_iProduct_Service.class => cct_Product_ServiceImpl.class,
        cct_iEvaluation_Service.class => cct_Evaluation_ServiceImpl.class 
    };
 // Create the UnitOfWorkFactory for this Application   
    public static  fflib_Application.UnitOfWorkFactory UnitOfWork 
        =  new fflib_Application.UnitOfWorkFactory( cct_Application.unitOfWorkTypes );

// Create the SelectorFactory for this Application
    public static  fflib_Application.SelectorFactory Selector 
        =  new fflib_Application.SelectorFactory( cct_Application.selectorTypeMap );
        
 // Create the DomainFactory for this Application    
    public static  fflib_Application.DomainFactory Domain 
        =  new fflib_Application.DomainFactory( cct_Application.Selector, cct_Application.domainTypesMap ); 
            
 // Create the ServiceFactory for this Application 
    public static  fflib_Application.ServiceFactory Service 
        = new fflib_Application.ServiceFactory( cct_Application.serviceTypesMap );
}