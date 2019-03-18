public class caseVerticalSidebarEXT {
    private Case oCase;
    public Contact oContact {get; set;}
    public List<Offer_sdo__c> oOffer {get; set;}
    public List<Order> oOrder {get; set;}
    private final String contactID;
    private final String caseID;
    
    public caseVerticalSidebarEXT(ApexPages.StandardController stdController) {
        this.oCase = (Case)stdController.getRecord();
        caseID = oCase.Id;
        if (caseID > ''){
            oCase = [SELECT Id, ContactId FROM Case WHERE Id=:caseID];
            contactID = oCase.ContactId;
            if (contactID > ''){
                oContact = [SELECT Id, AccountId,
                            (SELECT Id, Name, Status, Product2.Product_Image__c
                             FROM Assets
                             ORDER BY Status DESC LIMIT 3),
                            (SELECT Id, CreatedDate, ActivityDate, Subject
                             FROM ActivityHistories
                             ORDER BY ActivityDate DESC LIMIT 3),
                             (SELECT Id, CaseNumber, Status, Subject, LastModifiedDate
                              FROM Cases
                              WHERE Id <> :caseID
                              ORDER BY LastModifiedDate DESC LIMIT 3)
                            from Contact where Id=:contactID];

                oOffer = [SELECT Id, Name, Price__c, Product_Image__c FROM Offer_sdo__c];
                
                oOrder = [SELECT Id, Name, TotalAmount, EffectiveDate
                        FROM Order
                      WHERE AccountId = :oContact.AccountId];
            }
        }
    }
    public Contact getContact() {
        return oContact;
    }
    public List<Offer_sdo__c> getOffer() {
        return oOffer;
    }
    public List<Order> getOrder() {
        return oOrder;
    }
}