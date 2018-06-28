public class Code_Phase_controller {
    
     public Phase_Code_Bucket_Categories__c current_Phase_Code_Bucket{get;set;}
     public List<Phase_Code_Bucket_Categories__c> current_current_Phase_Code_items{get;set;}
     public List<String> categories=new List<String>();
     
     Integer flag;
    //Variables defined for Footer
    
    
    public double TotalOriginalBudget{get;set;}
    public double TotalCO{get;set;}
    public double TotalReEstimate{get;set;}
    public double TotalActualCost{get;set;}
    public double TotalRevisedBudget{get;set;}
    public double TotalOverUnder{get;set;}
   
    
    
    
    public Project__c current_project{get;set;}
    
       
    public Boolean render_all_stages{get;set;}
    
     private Map<String, Schema.sObjectField> fields_map{get;set;}
    
    public List<SelectOption> getstage_list(){
    
     
 
        fields_map = Schema.SObjectType.Phase_Code_Bucket_Categories__c.fields.getMap();
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('All', 'All'));
        for (Schema.PicklistEntry p : fields_map.get('Phase_Code__c').getDescribe().getPicklistValues()) {

            options.add(new SelectOption(p.getValue(), p.getLabel()));
            categories.add(p.getValue());
        }
        return options;
    }
    
    
    public Code_Phase_controller(ApexPages.StandardController sc){
        
        
        TotalOriginalBudget=0.0;
        TotalRevisedBudget=0.0;
        TotalCO=0.0;
        TotalReEstimate=0.0;
        TotalActualCost=0.0;
        
        TotalOverUnder=0.0;
        
        system.debug('Apex: Project Id = ' + sc.getId());
        current_project = [SELECT Id, Project_Ext_id__c, Name FROM Project__c WHERE Id = :sc.getId() LIMIT 1][0];
               
        
        if(current_project != null){
            
            
            fields_map = Schema.SObjectType.Phase_Code_Bucket_Categories__c.fields.getMap();
            List<SelectOption> options = new List<SelectOption>();
            
            for (Schema.PicklistEntry p : fields_map.get('Phase_Code__c').getDescribe().getPicklistValues()) {
            
            options.add(new SelectOption(p.getValue(), p.getLabel()));
            categories.add(p.getValue());
            }            
            current_current_Phase_Code_items = [SELECT Id,Name,Original_Budget__c,
            Project__c, Phase_Code__c,
            Projected_Budget__c,Actual_Cost__c,
            Revised_Budget__c,Re_estimate__c,C_O__c,Projected_Over_Under__c,
            Project_Ext_Id__c from Phase_Code_Bucket_Categories__c
                                                where Project__c =: current_project.Id];
                                       
                                        
           
           for(Phase_Code_Bucket_Categories__c p: current_current_Phase_Code_items){
           
                if(p.Original_Budget__c ==null){
                
                    p.Original_Budget__c=0.0;
                   
                
                
                }
                
                if(p.Revised_Budget__c ==null){
                    p.Revised_Budget__c=0.0;
                
                }
                
                
                
                if(p.Re_estimate__c ==null){
                
                p.Re_estimate__c=0.0;
                
                }
                if(p.C_O__c ==null){
                
                    p.C_O__c=0.0;
                
                }
                if(p.Projected_Over_Under__c ==null){
                
                    p.Projected_Over_Under__c=0.0;
                }
                
                
                if(p.Projected_Budget__c ==null){
                
                    p.Projected_Budget__c=0.0;
                }
                
                
                if(p.Actual_Cost__c ==null){
                
                    p.Actual_Cost__c=0.0;
                }
          
                
         
           
           }
           
           
          // current_current_Phase_Code_items[3].Projected_Over_Under__c=-2;
         //current_current_Phase_Code_items[3].re_Estimate__c=2;
           
           for(Phase_Code_Bucket_Categories__c pb: current_current_Phase_Code_items){
             
                TotalOriginalBudget=TotalOriginalBudget+pb.Original_Budget__c;
                TotalRevisedBudget=TotalRevisedBudget+pb.Revised_Budget__c;
                TotalCO=TotalCO+pb.C_O__c;
                TotalReEstimate=TotalReEstimate+pb.re_Estimate__c;
                TotalActualCost=TotalActualCost+pb.Actual_Cost__c;
                
                TotalOverUnder=TotalOverUnder+pb.Projected_Over_Under__c;
                
             
           }
        }
        
        system.debug('Apex: Phase Code Record length = ' + current_current_Phase_Code_items.size());
        
        if(categories.size() == current_current_Phase_Code_items.size()){
        
        
        
        
        }
        
        else{
        
          system.debug('Sobia' +  categories.size());
        
           for(String c: categories){
              //system.debug('Apex Category : ' + c);
             flag=0;
             if( current_current_Phase_Code_items.size() ==0 ){
             
             flag=1;
             
             
             }
             
             for(Phase_Code_Bucket_Categories__c pc: current_current_Phase_Code_items){
             
                       system.debug('Apex : ' + c);
                       
                       if(c  !=  pc.Phase_Code__c){
                            flag=1;
                       }      
                       
             
                }
                
                if(flag==1){
                
                        Phase_Code_Bucket_Categories__c code_bucket_cat=new Phase_Code_Bucket_Categories__c();
                        code_bucket_cat.Original_Budget__c=0.0;
                        code_bucket_cat.Phase_Code__c=c;
                        code_bucket_cat.Projected_Budget__c=0.0;
                        code_bucket_cat.Actual_Cost__c=0.0;
                        code_bucket_cat.Projected_Over_Under__c=0.0;
                        code_bucket_cat.C_O__c=0.0;
                        code_bucket_cat.Revised_Budget__c=0.0;
                        code_Bucket_cat.Re_estimate__c=0.0;
                        
                        current_current_Phase_Code_items.add(code_bucket_cat);
                }
           
           }
        
        
        
        }
        
         
        system.debug('Apex: length' + current_current_Phase_Code_items.size());
        render_all_stages = false;
    }
    
  
    
   
    
    
    
}