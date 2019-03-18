@isTest
public class TestGetUsableTaskDueDate{
    static testMethod void testTaskDueDate(){
        date myDate = date.today();
        Task t = new Task();
        t.ActivityDate = myDate;
        t.Description = 'Went terrible';
        t.Status = 'Dead';
        insert t;    
	}
}