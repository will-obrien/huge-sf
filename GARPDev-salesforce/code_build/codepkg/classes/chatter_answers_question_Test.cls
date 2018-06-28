@isTest(SeeAllData=true)
private class chatter_answers_question_Test {

    
    
    static testMethod void myUnitTest_2() {
    	Community community = [ SELECT Id FROM Community limit 1 ];
        Question question = new Question(priority = 'Medium',title = 'test',body = 'test',CommunityId = community.id);
        insert question;
        test.startTest();
        question.priority = 'High';
        update question;
        test.stopTest();
        
    }
}