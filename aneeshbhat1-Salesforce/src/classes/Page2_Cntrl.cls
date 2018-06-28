public class Page2_Cntrl {

    public PageReference Random() {
        return null;
    }


    public void InsertRecord() {
        Student__c newStudent=new Student__c(Student_Name__c='Arjun Mohan',Parent_Name__c ='Some Parent1',College__c='a042800000aiop7');
        insert(newStudent);
    }

    public List<Student__c> Opp{get;set;}
    public void UpdateRecord() {
        for(Student__c stud:Opp)
        {
            stud.Parent_Name__c ='Some Parent';
            update(stud);
        }
    }


    public void GetRecord() {
        Opp=[SELECT Student_Name__c, Name, Id, Parent_Name__c,College__c FROM Student__c WHERE Student_Name__c LIKE '%Arjun%'];
    }

}