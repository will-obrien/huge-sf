Public class loadingbarCtlr{
Public list<Contact> conlist{get;set;}
     Public loadingbarCtlr(){
     }
     Public Void demo(){
              conlist= [ select lastname from contact];
     }
}