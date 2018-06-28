/**
 * Helper class to avoid recursive triggers. Class body copied from: http://developer.force.com/cookbook/recipe/controlling-recursive-triggers
 */
public class RecursiveTriggerHelper {

    // Static variables are local to the context of a Web request
    // (or testMethod during a runTests call)
    // Therefore, this variable will be initialized as false
    // at the beginning of each Web request which accesses it.

    private static boolean recursiveFlag = false;

    public static boolean hasRecursiveFlag() {
        return recursiveFlag;
    }

    // By setting the variable to true, it maintains this
    // new value throughout the duration of the request
    // (or testMethod)

    public static void setRecursiveFlag() {
        recursiveFlag = true;
    }
}