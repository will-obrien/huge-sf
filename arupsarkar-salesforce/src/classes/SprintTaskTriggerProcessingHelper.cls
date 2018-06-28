public class SprintTaskTriggerProcessingHelper
{

    // Static variables are local to the context of a Web request  
    // (or testMethod during a runTests call)  
    // Therefore, this variable will be initialized as false  
    // at the beginning of each Web request which accesses it.

    private static boolean IsProcessing = false;

    public static boolean beforeProcessing() {
        return IsProcessing ;
    }

    // By setting the variable to true, it maintains this  
    
    // new value throughout the duration of the request  
    
    // (or testMethod)  
    
    public static void afterProcessing() {
        IsProcessing = true;
    }
}