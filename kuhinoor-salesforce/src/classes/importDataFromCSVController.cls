public class importDataFromCSVController {
public Blob csvFileBody{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}
public List<account> acclist{get;set;}
  public importDataFromCSVController(){
    csvFileLines = new String[]{};
    acclist = New List<Account>(); 
  }
  
  public void importCSVFile(){
   String val ='';
       try{
           csvAsString = csvFileBody.toString();
           csvFileLines = csvAsString.split('\n'); 
            
           for(Integer i=1;i<csvFileLines.size();i++){
               Account accObj = new Account() ;
               string[] csvRecordData = csvFileLines[i].split(',');
               accObj.name = csvRecordData[0] ;
                 if (csvRecordData[1].startsWith('"') && csvRecordData[1] .endsWith('"')){  
                    val =  csvRecordData[1].replaceAll('\n','');  
                 }  
                 else{  
                // val = csvRecordData[1].replaceAll('DBLQT','"');  
                  val = csvRecordData[1].replaceAll('\n',''); 
             }        
               accObj.Description= val;                                      
               acclist.add(accObj);
           }
        insert acclist;
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
  }
}