public class RecursiveBlockerAction{
    @InvocableMethod(Label='Get and Set the recursive block' Description='Prevents recursion')
    public static List<Boolean> doRecursiveBlockAction(List<id> objids){
        List<boolean> runlist = new List<boolean>();
        for(ID objid :objids){
            Boolean runvalue = RecursiveBlocker.isFirstRun? true : false;        
            runlist.add(runvalue);
		}
		RecursiveBlocker.isFirstRun = false;
       system.debug('@asha: @debug: RecursiveBlockerAction: setting recursive block.');
       return runlist; 
     }
}