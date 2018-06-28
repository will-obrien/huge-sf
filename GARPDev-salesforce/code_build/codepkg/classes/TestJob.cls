global class TestJob implements Schedulable {
    
    global void execute(SchedulableContext SC) {
		testJobClass.testJobMethod();  
    }
}