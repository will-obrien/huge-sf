Global class SchedEvalsDelete implements Schedulable{
    global void execute (SchedulableContext SC){
        //Instantiate
        EvalsDelete EvalsDelete = new EvalsDelete();
        //Delete Eval Leaders     
            EvalsDelete.DeleteEvalLeaders();
    }    
}