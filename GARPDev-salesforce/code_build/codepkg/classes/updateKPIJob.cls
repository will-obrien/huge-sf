global class updateKPIJob implements Schedulable {
    
    global void execute(SchedulableContext SC) {
		UpdateKPI.updateMethod(); 
    }
}