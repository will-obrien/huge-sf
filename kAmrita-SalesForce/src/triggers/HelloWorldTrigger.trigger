trigger HelloWorldTrigger on Book__c (Before insert) {
    Book__c[] books = Trigger.new;
    MyHelloWorld.applyDiscount(books);
}