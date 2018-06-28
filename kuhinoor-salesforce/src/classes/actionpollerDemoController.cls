Public with sharing class actionpollerDemoController{

Private DateTime dateAndTime;
Public Long dt{get;set;}


Public void dateTimeMethod(){
dateAndTime = System.now();
dt = dateAndTime.getTime()/1000;
}

    
    public String getTime() {
        return Datetime.now().format('hh:mm');
    }
  }