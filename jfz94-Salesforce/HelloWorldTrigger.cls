trigger HelloWorldTrigger on Book__c (before insert) {
	/*
	 * creates a list of books
	 * Assigns it the content of the variable called Trigger.New
	 * Trigger.new is a Trigger context variable 
	 * Containts new books that are about to be inserted 
    */
    Book__c[] books = Trigger.new;
    // calling to the method of the class MyHelloWorld //
    MyHelloWorld.applyDiscount(books);
}
