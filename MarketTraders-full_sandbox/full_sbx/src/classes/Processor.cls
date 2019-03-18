/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       3/9/2015
*   Author:             Asha Calderon
*   Last Modified:      10/12/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/

public abstract class Processor {
    
    /** 
    *
    *   @author: Jim Hutcherson 
    *   @description: Abstract Processor class that allows for defined methods and properties shared between concrete processors.
    * 
    **/
    protected set<String> noTouchOppStages = new set<String>{'Pending Charge','Pending Signature','Pending Post-Signature','Closed Won','Closed Won - Recovered Bad Debt'};
    protected map<String,String> monthConversionMap = new map<String,String>{'jan'=>'1','feb'=>'2','mar'=>'3','apr'=>'4','may'=>'5','jun'=>'6','jul'=>'7','aug'=>'8','sep'=>'9','oct'=>'10','nov'=>'11','dec'=>'12'};
    
    public Id processId = null;
    public String getProcessId(){
        return this.processId;
    }
    
    protected ProcessorConfiguation configuration;
    public ProcessorConfiguation getConfiguration(){
        return this.configuration;
    }
    
    protected Processor_Log__c log;
    public Processor_Log__c getLog(){
        return this.log;
    }
   
    /** 
    *   @method: refreshLog
    *   
    *   @description: queries all the data for the processor log record
    * 
    **/   
    public void refreshLog(){
        Id logId = this.log.id;
        Schema.DescribeSObjectResult describe = Processor_Log__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fields = describe.fields.getMap();
        String SOQL = 'Select '; 
        for (String fieldName : fields.keySet()){
            System.debug('fieldName: ' + fieldName);
            SOQL += fieldName + ',';  
        } 
        SOQL = SOQL.substring(0,SOQL.length()-1);
        SOQL += ' FROM Processor_Log__c WHERE ID = :logId LIMIT 1';        
        this.log = Database.query(SOQL);
    }
   
   
    public ApexPages.StandardSetController recordSetController {get;set;}
    
    /** 
    *   @method: records
    *   
    *   @description: helps with creation of list controllers like visualforce list controllers
    * 
    **/  
    public List<SObject> records {
        get {
            if(this.recordSetController == null)
                return new list<SObject>();
            return this.recordSetController.getRecords();
        }
    }
    
    /******************************
    *   @method: hasNext
    *   
    *   @description: if there are more records after the current page set then true
    * 
    **/ 
    public Boolean hasNext {
        get {
            if(this.recordSetController == null)
                return false;
            return this.recordSetController.getHasNext();            
        }
        set;
    }
    
    /******************************
    *   @method: hasPrevious
    *   
    *   @description: if there are more records before the current page set then true
    * 
    **/    
    public Boolean hasPrevious {
        get {
            if(this.recordSetController == null)
                return false;
            return this.recordSetController.getHasPrevious();
        }
        set;
    }
    
    /******************************
    *   @method: first
    *   
    *   @description: returns the first page set of records
    * 
    **/ 
    public void first() {
        if(this.recordSetController != null){
            this.recordSetController.first();
        }
    }
  
    /******************************
    *   @method: last
    *   
    *   @description: returns the last page set of records
    * 
    **/ 
    public void last() {
        if(this.recordSetController != null){
            this.recordSetController.last();
        }
    }
  
  
    /******************************
    *   @method: previous
    *   
    *   @description: returns the previous page set of records
    * 
    **/ 
    public void previous() {
        if(this.recordSetController != null){
            this.recordSetController.previous();
        }
    }
  
    /******************************
    *   @method: previous
    *   
    *   @description: returns the next page set of records
    * 
    **/ 
    public void next() {
        if(this.recordSetController != null){
            this.recordSetController.next();
        }
    } 
    

    public String presenter {get;set;}
    public String secondaryPresenter {get;set;}
    public String discountType {get;set;}
    public String discount {get;set;}
    public String downPayment {get;set;}
    public Date webinarDate {get;set;}
    public String webinarId {get;set;}
    //aac added 10.12.15
    public String selectedWebinar {get;set;}   
    public String webinartypeother {get;set;}
    public String leadtypeother {get;set;}
    public String opprectypeother {get;set;}
    public String producttypeother {get;set;}   
    public Webinar__c webinar {
        get{
            if(this.webinar == null)
                this.webinar = new Webinar__c();
            return this.webinar;
        }
        set;
    }
    

    /******************************
    *   @method: intializeLog
    *   
    *   @description: processor log object records information initializer
    * 
    **/     
    public void intializeLog(){
        this.log = new Processor_Log__c();
        this.log.Did_attend__c = 0;
        this.log.Did_not_attend__c = 0;
        this.log.Number_of_Converted_Leads__c = 0;
        this.log.Number_of_Employees_Registered__c = 0;
        this.log.Number_of_Failed_Converted_Leads__c = 0;
        this.log.Number_of_New_Deals__c = 0;
        this.log.Number_of_New_Opps__c = 0;
        this.log.Number_of_Registered__c = 0;
        this.log.Number_of_Tasks_Created__c = 0;
        this.log.Number_of_Tasks_Found__c = 0;
        this.log.Number_of_Total_Opps__c = 0;
        this.log.Number_of_Untouched_Opps__c = 0;
        this.log.Number_of_Updated_Opps__c = 0;
        this.log.Number_of_Webinar_Attendance_Created__c = 0;
        this.log.Number_of_Webinar_Attendance_Found__c = 0;
    }
    
    /******************************
    *   @method: getDiscountTypes
    *   
    *   @description: Processor Picklists
    *
    **/
    public List<SelectOption> getDiscountTypes(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-1','--none--'));
        options.add(new SelectOption('percent','Percent'));
        options.add(new SelectOption('dollar','Dollar'));
        return options;
    }
    
    list<String> defaultPercentDiscounts = new list<String>{'5','10','15','20','25','30','35','40','45','50','55','60'};
    list<String> defaultDollarDiscounts = new list<String>{'500','750','1000','1250','1500','1750','2000','2250','2500','2750','3000'};
    
    /******************************
    *   @method: getDiscounts
    *   
    *   @description: get the discount dollar fields and adds it as options for the visualforce page
    *
    *   @return: returns the picklist
    *
    **/
    public List<SelectOption> getDiscounts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','--none--'));
        if(this.discountType == 'percent'){
            for(String percent : defaultPercentDiscounts){
                options.add(new SelectOption(percent, percent + '%'));
            }
        }else if(this.discountType == 'dollar'){
            for(String dollar : defaultDollarDiscounts){
                options.add(new SelectOption(dollar, '$' + dollar));
            }
        }
        return options;
    }
    
    /******************************
    *   @method: getDiscounts
    *   
    *   @description: get the discount dollar fields and adds it as options for the visualforce page
    *
    *   @return: returns the picklist
    *
    **/
    public List<SelectOption> getDownPayments() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','--none--'));
        for(String dollar : defaultDollarDiscounts){
            options.add(new SelectOption(dollar, '$' + dollar));
        }
        return options;
    }
    
    /**  
    *
    *   @methods: configure, parseData, updateWebinar, preprocess, getOpportunityOwners
    *    run, getOpportunities,getWebinarAttendanceComponent, getWebinars
    *
    *   @description: Processor Methods to be instantiated by specific processors. 
    *   Each of these methods is called from different actions in the Processor Controller.
    *
    **/
    public abstract void configure();
    public abstract void parseData(String dataToParse);
    public abstract void updateWebinar();
    public abstract void preprocess();
    public abstract PageReference run();
    
    public abstract Component.Apex.OutputPanel getOpportunities();
    public abstract Component.Apex.OutputPanel getWebinarAttendanceComponent();

    public abstract List<SelectOption> getWebinars();
    public abstract map<String,String> getOpportunityOwners();

}