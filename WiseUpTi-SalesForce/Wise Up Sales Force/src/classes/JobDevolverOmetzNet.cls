global class JobDevolverOmetzNet implements Schedulable{
    
    global static void scheduleMeEvery15Minutes(){
        JobDevolverOmetzNet m = new JobDevolverOmetzNet ();
        
        String sch = '0 0 * * * ?';
        if(Test.isRunningTest()){
        	String jobID = system.schedule('Devolver OmetzNet  00\''+ Math.random(), sch, m);
    
            sch = '0 15 * * * ?';
            jobID = system.schedule('Devolver OmetzNet  15\'' + Math.random(), sch, m);  
    
            sch = '0 30 * * * ?';
            jobID = system.schedule('Devolver OmetzNet  30\'' + Math.random(), sch, m);  
    
            sch = '0 45 * * * ?';
            jobID = system.schedule('Devolver OmetzNet  45\''+ Math.random(), sch, m);   	
        }else{
            String jobID = system.schedule('Devolver OmetzNet  00\'', sch, m);
    
            sch = '0 15 * * * ?';
            jobID = system.schedule('Devolver OmetzNet  15\'', sch, m);  
    
            sch = '0 30 * * * ?';
            jobID = system.schedule('Devolver OmetzNet  30\'', sch, m);  
    
            sch = '0 45 * * * ?';
            jobID = system.schedule('Devolver OmetzNet  45\'', sch, m);   
        }
    }
    
    global void execute(SchedulableContext ctx) {
        
        Atualiza_Status_Lead_Novo.AtualizaLeadEnviarOmetzNet();
    }
    
}