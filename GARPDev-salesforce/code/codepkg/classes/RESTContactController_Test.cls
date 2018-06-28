@isTest
private class RESTContactController_Test {

    static testMethod void myUnitTest() {
        RESTContactController.sendContactUs('test@test.com', 'Membership', 'test');
        RESTContactController.sendContactUs('test@test.com', 'Exams', 'test');
        RESTContactController.sendContactUs('test@test.com', 'CPD', 'test');
        RESTContactController.sendContactUs('test@test.com', 'Marketing', 'test');
        RESTContactController.sendContactUs('test@test.com', 'General', 'test');
        
    }
}