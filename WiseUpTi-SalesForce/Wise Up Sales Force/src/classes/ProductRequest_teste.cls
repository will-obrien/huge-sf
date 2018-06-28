@isTest
public class ProductRequest_teste{
   public testmethod static void teste(){
        ProductRequest req = new ProductRequest();
        req.pkProductDefault = 1;
        req.product = '';
        req.state = '';
        req.city = '';
        req.unit = '';
        req.minEnrollment = 25;
        req.maxEnrollment = 25;
        req.scholarshipEnrollment = 25;
        req.minMonthPayment = 25;
        req.maxMonthPayment= 25;
        req.scholarshipMonthPayment = 25;
        req.user = '';
        req.status = '';
        req.created = '';
        req.edited = '';
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Física').getRecordTypeId();
        acc.FirstName = 'Teste';
        acc.LastName = 'Migueis';
        acc.CPF__pc = '019.781.981-83';
        acc.PersonBirthDate = System.Today().addYears(-25);
        acc.CPF_validado__c = true;
        insert acc;
        
        Opportunity opp = Teste_Util.newOpportunity(acc.Id);
        
        Product2 prod = Teste_Util.newProduct2();
        PricebookEntry pe = Teste_Util.newPriceBookEntry(prod.Id);
        OpportunityLineItem oli = Teste_Util.newOpportunityLineItem(opp.Id, pe.Id);
        
        try{
            ProductRequest.futureIntegrateOli(new List<Id>{oli.Id});
        }catch(Exception ex){
        }
   }           
}