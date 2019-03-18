/*
    Test class: SFRequest_Schedule_Test
*/

global class SFRequest_Schedule implements Schedulable{

    global void execute(SchedulableContext sc){
        delete
            [SELECT Id
            FROM Log_integracao__c
            WHERE CreatedDate <: System.today() - 30];
    }
    
    public void executar(){
        execute(null);
    }

}