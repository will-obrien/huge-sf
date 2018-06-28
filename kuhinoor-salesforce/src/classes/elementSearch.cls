Public Class elementSearch{
   Public Contact con{get;set;}
   public List<Date> datelist{get;set;} 
   Public List<lightingprefix__job__c> joblist;
   
   Public Map<String,map<date,integer>> drawingmap; 
   Public Map<String,map<date,integer>> productionmap; 
   Public Map<String,map<date,integer>> installationmap; 
   
   Public List<modelclass> models{get;set;}
   Public List<modelclass> modelsnew{get;set;}
   Public String findid{get;set;}
   Public String finddate{get;set;}
  
   Public Date mydate;
   Public Date mydate1;
   public String dateType {get;set;}
   Public List<lightingprefix__Element__c> elementslist{get;set;}
   
   //-----constructactor------
    public elementSearch(){
        datelist = new List<Date>();
        con = new Contact();
        DateTime dt = system.now();
        System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+dt);
        
        Date currentdate=dt.date();
         System.debug('--------------------->>>'+currentdate);
        con.StartDate__c = currentdate;
        con.EndDate__c = currentdate;
        dateType = 'Drawing';
          
    }  
   
    public void go(){
    
       //---------------------------------------------------------------------------------------------
       
        elementslist = new List<lightingprefix__Element__c>();
        models = new List<modelclass>();
        modelsnew = new List<modelclass>();
        //elemntlist = new List<lightingprefix__Element__c>();        
       
        datelist = new List<Date>();
        joblist = new List<lightingprefix__job__c>();
        joblist = [select id,(select id,name,lightingprefix__DrawingDate__c,lightingprefix__Installation_date__c,lightingprefix__Production_date__c from lightingprefix__Elements__r) from lightingprefix__Job__c];
      
        drawingmap = new  Map<String,map<date,integer>>();
        productionmap =new  Map<String,map<date,integer>>();
        installationmap = new  Map<String,map<date,integer>>();
        
        for(lightingprefix__job__c j : joblist){  
        
        //----------------------code for fillup drawingmap------------
            map<date,integer> temmap = new map<date,Integer>();
            for(lightingprefix__Element__c e : j.lightingprefix__Elements__r){
                Integer count=temmap.get(e.lightingprefix__DrawingDate__c);
                if(count==null){
                    count=0;
                }
                count++;
                temmap.put(e.lightingprefix__DrawingDate__c,count);
            }
            drawingmap.put(j.id,temmap);
            
        //-----------------------code for fillup Productionmap ------------  
        map<date,integer> temmap2 = new map<date,Integer>();
            for(lightingprefix__Element__c e : j.lightingprefix__Elements__r){
                Integer count=temmap2.get(e.lightingprefix__Production_date__c );
                if(count==null){
                    count=0;
                }
                count++;
                temmap2.put(e.lightingprefix__Production_date__c,count);
            }
            productionmap.put(j.id,temmap2);
            
         //-----------------------code for fillup installation map ------------  
         
          map<date,integer> temmap3 = new map<date,Integer>();
            for(lightingprefix__Element__c e : j.lightingprefix__Elements__r){
                Integer count=temmap3.get(e.lightingprefix__Installation_date__c);
                if(count==null){
                    count=0;
                }
                count++;
                temmap3.put(e.lightingprefix__Installation_date__c,count);
            }
            installationmap.put(j.id,temmap3);
        }
       
       
        models.clear();
       Date dt;
       //------------------------------------------------------------------------------------------
       for(lightingprefix__Element__c e: [select id,lightingprefix__DrawingDate__c,lightingprefix__Installation_date__c,lightingprefix__Production_date__c,lightingprefix__job__r.id,lightingprefix__job__r.name from lightingprefix__Element__c]){
           System.debug('@@@@@@@@@@@@@@@@@@@@@@@@'+e); 
           
          //-------------code for drawing count------------------       
          map<date,Integer> drawing = new map<date,Integer>();
          drawing=drawingmap.get(e.lightingprefix__job__r.id);
           
          map<date,Integer> production= new map<date,Integer>();
          production=productionmap.get(e.lightingprefix__job__r.id);
          
          map<date,Integer> installation= new map<date,Integer>();
          installation=installationmap.get(e.lightingprefix__job__r.id);
          
           
          //-----------model class memory allocation---------
            
          modelclass model = new modelclass();
          model.drawcountlist = new List<countclass>();
          model.Productionlist= new List<countclass>();
          model.installationlist= new List<countclass>();
           
          datelist.clear();
          for(dt=con.startdate__C;dt<=con.enddate__C;dt=dt.addDays(1)){
              countclass c = new countclass(); 
              if(drawing != null ){
                  
                  c.drawcount=drawing.get(dt);
                  c.hiddendate=dt.format();
                  c.hiddendatecolor=dt;
                  
              }
              countclass c2 = new countclass();
              if(production!=null){
                  c2.productioncount=production.get(dt);
                  c2.hiddendate=dt.format();
                  c2.hiddendatecolor=dt;
              }
              countclass c3 = new countclass();
              if(installation!=null){
                  c3.installationcount=installation.get(dt);
                  c3.hiddendate=dt.format();
                  c3.hiddendatecolor=dt;
              }
              
              System.debug('**************************'+dt);
               model.drawcountlist.add(c); 
               model.Productionlist.add(c2); 
               model.installationlist.add(c3);        
              datelist.add(dt);
              
           }
         //-------------code is end  for drawing count------------------ 
          
       //-------------code for production count-----------------------   
       
              
       //-------------code for production count-----------------------  
           model.jobid=e.lightingprefix__job__r.id;  
           model.jobname = e.lightingprefix__job__r.name; 
           models.add(model);
      }
      Set<String> idset = new Set<String>();
      for(modelclass md : models){
          if(!idset.contains(md.jobid)){
              modelsnew.add(md);
          }
          idset.add(md.jobid);
      }  
  }
  
   public void fillpopup(){
        elementslist.clear();
        System.debug('!!!!!!!!!!!!!!!!!');
        mydate1 = Date.parse(finddate);
       
        System.debug('!!!!!!!!!!!!!!!!!'+mydate1);
       // mydate = mydate1.format('dd/MM/yyyy');
        for(lightingprefix__job__c j : joblist){
            if(j.id == findid){
              for(lightingprefix__Element__c e : j.lightingprefix__Elements__r){
                  /*lightingprefix__Element__c  e1 = new lightingprefix__Element__c (job__c = e.id);
                  e1.id = e.id;
                  
                  if(mydate1 == e.lightingprefix__DrawingDate__c){
                      e1.lightingprefix__DrawingDate__c = e.lightingprefix__DrawingDate__c;
                  }
                  
                  if(mydate1 == e.lightingprefix__Production_date__c){
                      e1.lightingprefix__Production_date__c= e.lightingprefix__Production_date__c;
                  }
                  
                   if(mydate1 == e.lightingprefix__Installation_date__c){
                      e1.lightingprefix__Installation_date__c= e.lightingprefix__Installation_date__c;
                  }*/
                  if(dateType == 'Drawing' && mydate1 == e.lightingprefix__DrawingDate__c){
                      elementslist.add(e);
                  }else if(dateType == 'Production' && mydate1 == e.lightingprefix__Production_date__c){
                      elementslist.add(e);
                  }else if(dateType == 'Installation' && mydate1 == e.lightingprefix__Installation_date__c){
                      elementslist.add(e);
                  }
                  
              }
            }
        }
    }
   Public void savechanges(){
       update elementslist;
       go();
     //  return new pageReference('/apex/elementSearchpage').setRedirect(false);
   } 
  
  Public Class modelClass{
      Public String jobid{get;set;}
      Public String jobname{get;set;}
      Public List<countclass> drawcountlist{get;set;}
      Public List<countclass> Productionlist{get;set;}
      Public List<countclass> installationlist{get;set;}
  }
  Public class countclass{
      public Integer drawcount{get;set;}
      public Integer productioncount{get;set;}
      public Integer installationcount{get;set;} 
       
      Public String hiddendate{get;set;}
        Public Date hiddendatecolor{get;set;}
  }
}