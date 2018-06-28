global class JobLeadsDistruibicaoNoturna implements Schedulable{
    
    global static void scheduleMe23_50(){
        
        JobLeadsDistruibicaoNoturna m = new JobLeadsDistruibicaoNoturna();
        String sch = '0 50 23 * * ?';
        if(Test.isRunningTest()){
            String jobID = system.schedule('Distribuição Noturna dos Leads 23:50' + Math.random(), sch, m);
        }else{
        	String jobID = system.schedule('Distribuição Noturna dos Leads 23:50', sch, m);
        }
    }
    
    global void execute(SchedulableContext ctx) {
        
        BatchLeadsForaDoFunil a = new BatchLeadsForaDoFunil();
        Database.executeBatch(a, 1);
    }
    
    
}