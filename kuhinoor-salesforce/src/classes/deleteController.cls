Public class deleteController{
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    List<SelectOption> ObjectNames{get;set;}
    Public String selectedObject{get;set;}    
    Public String ObjectType {get;set;}
    Public List<Selectoption> fields{get;set;}
    Public list<Model> modellist{get;set;}
    Public List<contact> con{get;set;}
    Public Integer DelIndex{get;set;}
    
    //--------------list for delete record----------
    Public List<sObject> deleteList{get;set;}
    Public List<sObject> undolist{get;set;}
    Public List<model> modelListnew{get;set;}
    
    Public DeleteController(){   
         con = new List<contact>();
         ObjectNames  = new List<SelectOption>(); 
         fields = new List<Selectoption>();
         modellist = new List<Model>();
        
        
         // getIteams();
       }
      
      Public List<selectoption> getIteams(){   
         objectnames.clear();
          ObjectNames  = new List<SelectOption>();    
          for(schema.sobjectType type : Schema.getGlobalDescribe().values()){
              String objname = String.valueOf(type);
             
              if(ObjectType != null && ObjectType.equals('standard') && !objname .contains('__c')){
                  objectnames.add(new SelectOption(objname,objname));
              }
              if(ObjectType != null && ObjectType.equals('custom') && objname .contains('__c')){
                  objectnames.add(new SelectOption(objname,objname));
                  
              }
              if(ObjectType ==null ){
                  ObjectNames.add(new selectoption(objname,objname));
              }
          }
          return objectnames;
      } 
      Public void test(){
           getIteams();
      } 
      
      
      public void showFields(){
      fields.clear();
      modelList.clear();
      
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('=','equal'));
      options.add(new SelectOption('Like','%'));
      options.add(new SelectOption('!=','NotEquals'));
     
      List<selectoption> symbollist = new List<SelectOption>();
      symbollist.add(new SelectOption('NONE','--NONE--'));
      symbollist.add(new SelectOption('AND','AND'));
      symbollist.add(new SelectOption('OR','OR'));
      
         Model md = new Model();  
         md.picklist=new contact();
         md.conditionlist=options;
         md.symbol=symbollist;
         
        //fields.clear();
        system.debug('$$$$$' + selectedObject);
       
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
        schema.describefieldresult dfield = sfield.getDescribe();
        system.debug('#######' + dfield.getLabel());
            //fields.add(new SelectOption(dfield.getlabel(),dfield.getlabel()));   
              fields.add(new SelectOption(dfield.getName(),dfield.getlabel()));     
          
            
        }
         md.fieldname = fields;
         
         md.selectfieldname='';
         modelList.add(md);
      }
      
      public void conditionmethod(){
             
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('=','='));
      options.add(new SelectOption('Like','Like'));
      options.add(new SelectOption('Not Equals','NotEquals'));
      
       
      List<selectoption> symbollist = new List<SelectOption>();
       symbollist.add(new SelectOption('NONE','--NONE--'));
      symbollist.add(new SelectOption('AND','AND'));
      symbollist.add(new SelectOption('OR','OR'));
     
         Model md = new Model();  
         md.picklist=new contact();
         md.conditionlist=options;       
         md.fieldname = fields;
         md.symbol=symbollist;
         modelList.add(md);
      }
      
       Public void Allobjects(){
           getIteams();
      } 
      
      //-------- code for Delete all record of a object-------------------
      
       Public void deleteall(){
          String queryalldelete = 'select id from '+selectedObject;
          System.debug('!!!!!!!!'+queryalldelete);
         // List<sobject> delList = Database.query(query);
         // Delete delList;
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Succesfully deleted'));
      }
      
      
      
      
      Public void deletewithCondition(){
      
      modelListnew = new List<model>();
      undolist = new List<sobject>();
      String fieldsnamesString='';
      String fieldsnamesStringnew;
      String condition='';
      String textnew='';
      String logicalopratornew='';
       String query='';
       String querynew='';
      List<String> fname= new list<String>();
      List<String> condi = new list<String>();
      List<String> txtlist = new list<String>();
      List<String> logical = new list<String>();
         for(model m : modellist){
            
            //-------------------------------------------
           String s = m.txt;
           System.debug('------------------>>>'+s);
            fname.add(m.selectfieldname);
            condi.add(m.operator);
            txtlist.add(m.txt);
            logical.add(m.logicaloprator);         
            
            //------------------------------------------------
            
              fieldsnamesString+=m.selectfieldname+',';
              //condition = m.operator;
             
             // textnew=m.text;
           
                 if(fieldsnamesString.EndsWith(',')){
                     fieldsnamesStringnew=fieldsnamesString.removeEnd(',');
                     System.debug('$$$$$$$$'+fieldsnamesStringnew);
                 }
         }
         
            for(Integer i=0 ;i<fname.size();i++){
                 query+=( fname.get(i)+condi.get(i)+'\''+txtlist.get(i)+'\''+logical.get(i)+' ');
                  System.debug('######'+query);
              
             }
            if(query.EndsWith('NONE ') || query.EndsWith('AND') || query.EndsWith('OR')){
               querynew = query.removeEnd('NONE ');
              // querynew = query.removeEnd('AND');
               //querynew = query.removeEnd('OR');
               System.debug('-------->>>'+querynew);
           }
           String executionQuery = 'select '+fieldsnamesStringnew+' from '+selectedObject +' Where '+querynew;
           System.debug('++++++++++++++++++++++'+executionQuery);
           deleteList= Database.query(executionQuery);
         
           delete deleteList;
           
           for( sObject obj : deletelist){
              
               undolist.add(obj);
           }
            model md = new model();
            for(String s : fname){
                md.Undofieldname=s;
            }
            for(String s : txtlist){
                md.undotxtlist=s;
            }
            modelListnew.add(md);
           //System.debug('************************'+modelListnew.get(fieldname));
      }
      Public void Undo(){
          insert deleteList;
         /* if(selectedObject!=null){
              for(selectedObject s : modelListnew){
              
              }
          }*/
          
          
      }
      //----------------------------Delete Row method---------------------------
      Public Void Del(){
          modelList.remove(DelIndex);
          
      }
     
      
    Public Class model{
        Public Contact picklist{get;set;}
        Public List<Selectoption> fieldname{get;set;}
        Public List<Selectoption> conditionlist{get;set;}
        Public List<Selectoption> symbol{get;set;}
        Public Contact text{get;set;}
        Public String txt{get;set;}
        Public String selectfieldname{get;set;}
        Public String operator{get;set;}
        Public String logicaloprator{get;set;}
        Public List<sObject> undolistnew{get;set;}
        Public String Undofieldname{get;set;}
        Public String undotxtlist{get;set;}
      /*  public model(Contact  picklist,Selectoption fieldname){
            this.picklist=picklist;
            this.fieldname=fieldname;
           } 
            */
        
        
    }
    
    
}