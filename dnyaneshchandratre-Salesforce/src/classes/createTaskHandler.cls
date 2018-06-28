public with sharing class createTaskHandler 
{
    public static void createTask(list<Account> accList)
    {
        list<Task> taskList= new list<Task>();
        for(Account a: accList)
        {
            taskList.add(new Task(Subject='Meeting with ' + a.Name));
        }
        System.debug('Contents of taskList : ' + taskList);
        insert taskList;
    }
}