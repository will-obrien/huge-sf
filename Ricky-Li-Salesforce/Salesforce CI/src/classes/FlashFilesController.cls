public class FlashFilesController {
   List <Document> listDoc = new list <Document>();
   Map <String, String> mapStringParam = new Map <String, String>();
   Public string SwfFile{get;set;}
   List <string> listStrParam = new list <String>();
   String DocName;
   Id DocId;
    public FlashFilesController(){
        mapStringParam = ApexPages.currentPage().getParameters();
        System.Debug(mapStringParam);
        //iterate over this map
        for(String str : mapStringParam.keySet()){
           System.Debug(str);
           if(str == 'swf'){
             DocName = mapStringParam.get(str);
             System.Debug(DocName);
           }
        }
        if(mapStringParam.keySet().size() > 0){
           listDoc = [Select Id from Document where name =: DocName];
               if(listDoc !=null){
                   DocId = listDoc[0].Id;
                   swfFile = '/servlet/servlet.FileDownload?file='+DocId; 
               }
        }
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Check the name of the file!'));
    }   
}