global class MAPS_Delete_Old_Records_Scheduler implements Schedulable{
    
    global void execute(schedulableContext SC){
        MAPS_Delete_Old_Records deleteMAPS = new MAPS_Delete_Old_Records();
        deleteMAPS.deleteMAPSRecords();
    }
}