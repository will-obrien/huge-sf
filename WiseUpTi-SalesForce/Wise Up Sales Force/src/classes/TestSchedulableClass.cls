@isTest
private class TestSchedulableClass {
    
  
    static testmethod void JobLeadsDistruibicaoNoturna() {
        Test.startTest();
        ControleAtribuicaoComercial__c CAC = new ControleAtribuicaoComercial__c();
        CAC.LimiteLeads__c = 35;
        CAC.Name = 'meuSucesso #AUTO';
        CAC.IdFilaRoleta__c = '00G36000001crTC';
        INSERT CAC;
        
        // Schedule the test job
        JobLeadsDistruibicaoNoturna.scheduleMe23_50();
        
        Test.stopTest();
        
    }
    
    static testmethod void JobDevolverOmetzNet() {
        Test.startTest();
        
        JobDevolverOmetzNet.scheduleMeEvery15Minutes();
        
        
        Test.stopTest();
        
        
    }
    
}