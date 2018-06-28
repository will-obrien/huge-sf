trigger HelloWorld on Lead (before Update) {
    for (Lead l: Trigger.new){
        l.FirstName = 'Hello';
        l.LastName = 'World';
    }
}