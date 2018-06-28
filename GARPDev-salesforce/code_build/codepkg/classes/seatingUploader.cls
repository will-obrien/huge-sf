public class seatingUploader {
  public string nameFile{get;set;}
  public Blob contentFile{get;set;}
  String[] filelines = new String[]{};
  List<Exam_Attempt__c> EAs2Upload;
    
  public Pagereference ReadFile() {
    nameFile=contentFile.toString();
    filelines = nameFile.split('\n');
    EAs2Upload = new List<Exam_Attempt__c>();
    map<id, Exam_Attempt__c> EAid2EA = new map<id,Exam_Attempt__c> () ;
    set< id > EAids = new set< id >() ;
    try{    
        for (Integer i=1;i<filelines.size();i++)  {
          String[] inputvalues = new String[]{};
          inputvalues = filelines[i].split(',');
          Exam_Attempt__c ea = new Exam_Attempt__c();
          ea.id = inputvalues[0].replace( '"','') ;
          //ea.Section__c = inputvalues[6];       
          ea.Seat_No__c = inputvalues[7].replace( '"','');
          EAs2Upload.add(ea);
        }
    
    	update EAs2Upload;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }    
    return null;
  }
    
  public List<Exam_Attempt__c> getuploadedEAs() {
    if (EAs2Upload!= NULL)
      if (EAs2Upload.size() > 0)
        return EAs2Upload;
        else
        return null;                    
      else
      return null;
  }            
}