Public class demoControllernew{
    Private List<String> conList;
    Public List<String> records{get;set;}
    Integer start=0;
    Integer endno=999;
    Public demoControllernew(){
        conList = new  List<String>();
        for(Integer i=0;i<=5000;i++){
            conList.add('ibirds');
            conList.add('services');
        }
        System.debug('Size of list------->>'+conList.size());
        records = new List<String>();
        
        for(integer i=start;i<=endno;i++){
            records.add(conlist[i]);
        }
       
    }
    Public void next(){
         records.clear();
         start = endno;
         endno = endno+999;
         records = new List<String>();
         for(integer i=start ;i<endno ;i++){
            records.add(conlist[i]);
        }
    }
}