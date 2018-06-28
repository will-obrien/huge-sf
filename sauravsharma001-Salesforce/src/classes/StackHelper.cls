/*
Copyright 2012, Project WorldWide
*/
public with sharing class StackHelper {
    public class Frame {
        string classNameFrom(string aString)
        {
            string[] classPart = aString.split('\\.');

            string aName = '';
            for (integer i = 0; i < classPart.size() - 1; i++)
                aName += '.' + classPart[i];
    
            return aName.substring(1);
        }
        
        Frame(string each)
        {
            if (each.startsWith('Class.') == false)
                throw new StackHelperException('Frame is not a method : ' + each);
                
            printString = each;
            className = classNameFrom(each);
            methodName = methodNameFrom(each);
            lineNumber = lineNumberFrom(each);
        }
        
        public string getPrintString() { return printString; }  
        
        string lineNumberFrom(string aString) { return aString.split(':')[1]; }
        string methodNameFrom(string aString) { return aString.split(':')[0] + '()'; }
        
        public string className { get; private set; }
        public string methodName { get; private set; }
        public string lineNumber { get; private set; }
        string printString;
    }
    
    public StackHelper.Frame getFirstForeignFrame() {
        string aClassName = getMyFrame().className;
        
        for (StackHelper.Frame each : frameList)
            if (each.className != aClassName)
                return each;
        
        throw new StackHelperException('No foreign frames without ' + aClassName, ex);          
    }
    
    public StackHelper.Frame getMyFrame() { return frameList[0]; }
    
    public string getMyMethodName()
    {
        return getMyFrame().methodName;
    }
    
    public StackHelper.Frame getSenderFrame() { return frameList[1]; }
    
    public string getSenderMethodName()
    {
        return getSenderFrame().methodName;
    }
    
    public static string MyMethodName() {
        StackHelper aStack = new StackHelper();
        return aStack.getMyMethodName();
    }
    
    public static string SenderMethodName() {
        StackHelper aStack = new StackHelper();
        return aStack.getSenderMethodName();
    }   
    
    public StackHelper()
    {
        ex = new StackHelperException();
            
        try {
            for (string each : ex.getStackTraceString().split('\n')) {
                try {
                    Frame aFrame = new Frame(each);
                    if (aFrame.className != 'Class.StackHelper')
                        frameList.add(new Frame(each));
                }
                catch (StackHelperException aFrameException) {
                    // ignore
                }
            }
        }
        catch (Exception aGenericException)
        {
            throw new StackHelperException(ex.getStackTraceString(), aGenericException);
        }
    }
    
    list<StackHelper.Frame> frameList = new list<StackHelper.Frame>();
    StackHelperException ex;
}