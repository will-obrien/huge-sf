public class DiagnosticsInstrumentation {
	
	public static Boolean DiagnosticsEnabled = AppConfigSupport.DiagnosticsEnabled;
	
	private static List<DiagnosticEntry> DiagnosticLog;
	private static Integer CurrentLevel = 0;

	private static List<String> stacktrace = new List<String>();
	public static string ExceptionTrace = '';

	private class DiagnosticEntry
	{
		Integer level;
		String description;
		
		public DiagnosticEntry(string entrydescription)
		{
			level = CurrentLevel;
			description = entrydescription;
		}
	}

	public static void Push(String functionname)
	{
		Debug('Entering: ' + functionname);
		CurrentLevel+=1;
		Stacktrace.add(functionname);
	}
	
	public static void Debug(String debugstring)
	{
		if(!DiagnosticsEnabled) return;
		if(DiagnosticLog==null) DiagnosticLog = new List<DiagnosticEntry>();
		DiagnosticLog.add(new DiagnosticEntry(debugstring));
	}
	
	public static void DebugException(Exception ex)
	{
		String exceptioninfo = 'Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage() + ' stack: ' + ex.getStackTraceString();
		Debug(exceptioninfo);
		DebugInfo__c dbg = new DebugInfo__c(DebugData__c = CurrentLog());
		ExceptionTrace = ' Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage();
		for(String st: stacktrace) ExceptionTrace += ' | ' + st;
		ExceptionTrace += ' |\n ';
		if(DiagnosticsEnabled) insert dbg;
	}

	public static void Pop()
	{
		if(CurrentLevel>0) CurrentLevel-=1;
		if(CurrentLevel==0) System.Debug(LoggingLevel.Info, 'Diagnostic Log\n' + CurrentLog());
		if(StackTrace.size()>0) StackTrace.remove(StackTrace.size()-1);
	}
	
	public static void PopAll()
	{
		CurrentLevel=0;
		Pop();
	}
	
	public static String CurrentLog()
	{
		if(DiagnosticLog == null) return null;
		String spaces = '                                                                        ';
		String result = '';
		for(DiagnosticEntry de: DiagnosticLog)
		{
			Integer endindex = 3 * de.level;
			if(endindex >= spaces.length()) endindex = spaces.length()-1;
			result += spaces.substring(0,endindex) + de.description + '\n';
		}
		return result;
	}
	

	
}