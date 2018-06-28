global with sharing class ApexSOAPWebServices {

  webService static Case getCase(String caseNumber) {
    Case c= [SELECT Id,Subject,CaseNumber FROM Case WHERE CaseNumber= :caseNumber];
    return c;
        
  }

}