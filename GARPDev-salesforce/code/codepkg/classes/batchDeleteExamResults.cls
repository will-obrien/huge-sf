global class batchDeleteExamResults implements Database.Batchable<sObject>,Database.StateFul{

    global Database.QueryLocator start(Database.BatchableContext BC){

	return Database.getQueryLocator('select id from exam_result__C');         
    
    }
    
    global void execute(Database.BatchableContext BC, List<exam_result__C> lstExams){
        
        List<exam_result__C> lstToDelete = new List<exam_result__C>();
        for (exam_result__C ex : lstExams)
        {
            lstToDelete.add(ex);
        }
        Delete lstToDelete;
    }
    
     global void finish(Database.BatchableContext BC){
   
   }
    
}