trigger setDefaultPricebook2Values on Pricebook2(before insert, before update) {  
    for (Pricebook2 Book : trigger.new) {
        Book.Price__c = Book.Price__c * 0.5;
    }
}