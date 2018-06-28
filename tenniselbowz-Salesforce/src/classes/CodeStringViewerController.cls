public class CodeStringViewerController
{
    public Asset ast{get;set;}
    public class CodeStringRec
    {
       public String code_sequence{get;set;}
       public String code_value{get;set;}
       public String code_description{get;set;}
    
    }
    public CodeStringViewerController(ApexPages.StandardController ctl)
    {
       ast = [Select Id, Current_Code_String_Breakdown__c, Code_String_Breakdown__c from Asset where Id = :ctl.getId()];
    }

    public list<CodeStringRec> getCodeStringRecs()
    {
        list<CodeStringRec> recs = new list<CodeStringRec>();
        string codeStringBreakDown = '';
            
        if(ast.Current_Code_String_Breakdown__c != null) 
            	codeStringBreakDown = ast.Current_Code_String_Breakdown__c;
            else  
            	codeStringBreakDown = ast.Code_String_Breakdown__c;
            	
        try{
            JSONParser parser = JSON.createParser(codeStringBreakDown);
            string label = '';
            string value = '';
            while (parser.nextToken() != null) {
            // Start at the array of invoices.
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        // Advance to the start object marker to
                        //  find next invoice statement object.
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            // Read entire invoice object, including its array of line items.
                             CodeStringRec codeRec = (CodeStringRec)parser.readValueAs(CodeStringRec.class);
                             System.Debug(':::>'+codeRec);
                             recs.add(codeRec);
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.Debug('ERROR: '+e);
        }
        
        return recs;
    }
}