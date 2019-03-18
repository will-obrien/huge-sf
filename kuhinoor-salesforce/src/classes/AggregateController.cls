public class AggregateController{
    public list<ModelClass>Models{get;set;}
    public AggregateController(){
        List<aggregateResult> result =[Select count(id) sCount , Class__c cName from studentrecord__c group by class__c];
        Models = new List<ModelClass>();
        for(aggregateResult r : result){
            ModelClass model = new ModelClass();
            model.countStudents=(integer)r.get('sCount');
            model.className=(string)r.get('cName');
            Models.add(model);
        }
    }
    public class ModelClass{
        public integer countStudents{get;set;}
        public String className{get;set;}
    }
}