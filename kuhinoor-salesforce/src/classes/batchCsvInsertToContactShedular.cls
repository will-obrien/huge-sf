Global class batchCsvInsertToContactShedular Implements Schedulable{
   Global void execute(SchedulableContext sc){
        BatchClassForCsvInsert  obj = new BatchClassForCsvInsert();
        Database.executeBatch(obj,50);
   } 
}