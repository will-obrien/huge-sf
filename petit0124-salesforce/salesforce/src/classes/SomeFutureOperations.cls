public class SomeFutureOperations {
	
	private static Boolean FutureCallCalled = false;
	
	public static void DoFutureCall()
	{
		if(FutureCallCalled || System.isFuture()) return;
		FutureCallCalled = true;
		ActualFutureCall();
		// Code to call async here
	}
	
	@future
	private static void ActualFutureCall()
	{
		// Actual async code here
		system.debug('ActualFutureCall async operation');
	}
	
	

	
}