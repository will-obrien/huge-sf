public class contactRecordController{
    public  List <contact> record; 
    public String searchdata{get;set;}
    public  List  <contact> condata{get;set;}
    public Integer size;
           Integer start;
           Integer e;
           Integer startnew;
           Integer endnew;
    public contactRecordController(){
          start=0;
          e=9;
          startnew=0;
          endnew=9;
            record = [ select FirstName,lastname,email from contact limit 100];
              
             next();
      }
      public void search(){
          
              Integer start=0;
              Integer e=9;
              system.debug('searchmethodcall brfore for loop----->>'+start+'end-------->'+e);
           // Integer startnew=0;
           // Integer endnew=9;
           // String query = 'select firstname,lastname from contact where firstname = :searchdata';
            //System.debug('@@@@@@@@@@----->'+query);
            //record.clear();
           // condata.clear();
            record = [ select FirstName,lastname,email from contact where FirstName LIKE : searchdata+'%'];
            
            next();
          
           
      }
      public void next(){
           system.debug('before for loop size of record----->'+record.size());     
           system.debug('before for loop----->>'+start+'end-------->'+e);
           condata = new List<contact>();
           
         for(integer i=start;i<=e;i++){
             if(i < record.size()){
              condata.add(record[i]);
              }  
              if(i > record.size()){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'No more data'));
             }
         }
          startnew = start-9;
          endnew = e-9;
          
        
             start = e;
             e = e+9;
             
        
          
           system.debug('start----->>'+start+'end-------->'+e); 
           system.debug('startnew----->>'+startnew+'endnew-------->'+endnew);  
            
         
      }
      public void previous(){
          condata = new List<contact>();
         system.debug('startnew----->>'+startnew+'endnew-------->'+endnew);
          for(Integer i=startnew;i<=endnew;i++){
              if(i< record.size())
              condata.add(record[i]);
          }
          system.debug('startnew********----->>'+startnew+'endnew-******------->'+endnew);
          start = endnew;
          e = endnew+9;
          endnew = startnew;
          startnew = startnew-9;
           
          system.debug('startnew----->>'+startnew+'endnew-------->'+endnew);
          system.debug('startnext----->>'+start+'endnext-------->'+e);
      }
      
    }