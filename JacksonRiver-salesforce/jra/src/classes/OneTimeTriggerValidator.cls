global class OneTimeTriggerValidator {
	private static boolean blnAlreadyDone = false;
	
	public static boolean isAlreadyDone() { 
		return blnAlreadyDone; 
	}

	public static void setAlreadyDone() {
		blnAlreadyDone = true;
	} 
	
	public static void reset() {
		blnAlreadyDone = false;
	}
}