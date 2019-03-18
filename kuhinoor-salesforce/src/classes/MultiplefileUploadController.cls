public class MultiplefileUploadController{ 
public list<Attachment> AttList{get;set;}  
public list<SelectOption> optList{get;set;}
Public Integer rows{get;set;}
      public MultiplefileUploadController(){
          Integer i=1;
          AttList = New list<Attachment>(); 
          optList = new list<SelectOption>();          
            optList.add(new SelectOption('1','1'));
            optList.add(new SelectOption('2','2'));
            optList.add(new SelectOption('3','3'));
            optList.add(new SelectOption('4','4'));  
      }
      public void AddRows(){
          Attlist.clear();
          for( Integer i=0;i<rows;i++){
              AttList.add(new Attachment());
          }
      }
}