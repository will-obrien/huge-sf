public with sharing class EvaluateStrategyController {
    private ApexPages.StandardSetController standardSetController = null; 
    public EvaluateStrategyController(ApexPages.StandardSetController controller) {
            standardSetController = controller;
    }
    public PageReference evaluateStrategy()
    {
        try
        {
            
            Set<ID> selectedStrategyIds = 
                new Map<ID, SObject>(standardSetController.getSelected()).keySet();
            //Call evaluation Strategy service
            cct_Evaluation_Service.evaluate(selectedStrategyIds);
            // Confirm submission
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Strategy Evaluated.'));
        }
        catch (Exception e)
        {
            ApexPages.addMessages(e);
        }       
        
        return null;                
    }
}