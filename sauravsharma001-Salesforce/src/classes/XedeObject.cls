public virtual class XedeObject {
    public void addDependent(XedeObject anObject)
    {
        if (anObject != null)
            dependents.add(anObject);
    }
    
    public void addErrorMessage(string message) {
        addMessage(Apexpages.Severity.ERROR, message);
    }
    
    public string addInfoMessage(string message) {
        StackHelper aStack = new StackHelper();
        addMessage(Apexpages.Severity.INFO, aStack.getFirstForeignFrame().getPrintString() + '\n' + message);
        return message;
    }
    
    public string addInfoMessage(string format, object arg1) {
        return addInfoMessage(String.Format(format, new string[] { '' + arg1 }));
    }
    
    public string addInfoMessage(string format, object arg1, object arg2) {
        return addInfoMessage(String.Format(format, new string[] { '' + arg1, '' + arg2 }));
    }
    
    public string addInfoMessage(string format, object arg1, object arg2, object arg3) {
        return addInfoMessage(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3 }));
    }
    
    public void addMessage(Apexpages.Severity aSeverity, string aMessage) {
        ApexPages.addMessage(new Apexpages.Message(aSeverity, aMessage));
    }    
    
    public void addWarningMessage(string message) {
        addMessage(Apexpages.Severity.WARNING, message);
    } 
       
    public date coalesce(date arg1, date arg2)
    {
        return arg1 == null ? arg2 : arg1;
    }
    
    public decimal coalesce(decimal arg1, decimal arg2)
    {
        return arg1 == null ? arg2 : arg1;
    }
    
    public string coalesce(string arg1, string arg2)
    {
        return String.IsBlank(arg1) ? arg2 : arg1;
    }
    
    public string coalesce(string arg1, string arg2, string arg3)
    {
        return coalesce(coalesce(arg1, arg2), arg3);
    }
    
    public string coalesce(ID arg1, string arg2)
    {
        return coalesce((string) arg1, arg2);
    }
    
    public virtual list<XedeObject> getDependents() { return dependents; }
    
    public virtual string printString() { return '' + this; }    
    
    public void removeDependent(XedeObject anObject)
    {
        if (anObject == null)
            return;
            
        list<integer> aList = new list<integer>();
        
        for (integer i = 0; i < dependents.size(); i++)
            if (dependents[i] == anObject)
                aList.add(i);
        
        for (integer i = aList.size() - 1; i > -1; i--)
            dependents.remove(aList[i]);
    }
        
    public string singleQuote(string aString) { return '\'' + aString + '\''; }

    protected list<XedeObject> dependents {
        get {
            if (dependents == null)
                dependents = new list<XedeObject>();
            
            return dependents;
        }
        
        private set;
    }
}