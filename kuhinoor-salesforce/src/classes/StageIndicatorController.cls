public class StageIndicatorController{
    
    //Color of Stages passed from component
    public String stageColors{
        get{return stageColors;}
        set{stageColors = value;}
    }
    //Comma seperated values from component
    public  string individualvalues{ 
        get{return individualvalues;}
        set{individualvalues = value;}
    }
    //Field API Name passed from component to get picklist values
    public  string fieldValues{ 
        get{return fieldValues;}
        set{fieldValues = value;}
    }
    //Current Value which is shown in different color passed from component
    public String currentValue{get;set;}
    
    public String prevClass{get;set;}
    public String currClass{get;set;}
    public String nextClass{get;set;}
    
    //Constructor
    public StageIndicatorController(){}
    //Getter to get values of stages 
    public List<StagesWrapper> getvaluesList(){
        try{
            if(!string.isBlank(stageColors) && stageColors.split(',').size() ==3){
                prevClass = stageColors.split(',').get(0).trim();
                currClass = stageColors.split(',').get(1).trim();
                nextClass = stageColors.split(',').get(2).trim();
            }
            List<StagesWrapper> stagesWrapperList = new List<StagesWrapper>();
            Boolean currentMatch = false;
            List<String> stagevalues = new List<String>();
            //If both comma seperated and API Name are blank
            if(string.isBlank(individualvalues) && string.isBlank(fieldValues)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please give values either in comma seperated or field API name.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            //If API Name given otherwise default use comma seperated values
            if(string.isBlank(individualvalues) && !string.isBlank(fieldValues)){
                stagevalues = pickListValues();
            }else{
                stagevalues  = individualvalues.split(',');
            }
            //Fill model class with different colors according to stage's level
            for(String nm : stagevalues ){
                
                //For current value and previous values
                String colorCode = currentValue == nm.trim() ? currClass : prevClass;
                //For next remaining
                if(currentMatch) colorCode = nextClass;
                if(currentValue == nm.trim() && !currentMatch) currentMatch =  true;
                stagesWrapperList.add(new StagesWrapper(nm.trim(),colorCode,prevClass,currClass,nextClass));
            }
            return stagesWrapperList;
        }catch(Exception e){
            ApexPages.addMessages(e); 
            return null;
        }
    }
    //Method to get picklist values using object field's API name which is passed from component
    private List<String> pickListValues(){
    
        //for all values in the picklist list  
        List<String> valList = new List<String>();       
        Schema.sObjectType sObjType = Schema.getGlobalDescribe().get(fieldValues.substring(0, fieldValues.indexOf('.', 0)));    
        Map<String, Schema.SObjectField> field_map = sObjType.getDescribe().fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldValues.substring(fieldValues.indexOf('.', 0)+1, fieldValues.length())).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) {                                        
            valList.add(a.getValue());
        }
        return valList;
    }
    //Wrapper class to show values of stages and color on page
    public class StagesWrapper{
    
        public String valName{get;set;}
        Public String color {get;set;}
        public String prevColor{get;set;}
        public String currColor{get;set;}
        public String nextColor{get;set;}
        public StagesWrapper(String vn,String c, String prevColor, String currColor, String nextColor){
            this.valName = vn;
            this.color = c;
            this.prevColor = prevColor;
            this.currColor = currColor;
            this.nextColor = nextColor;
        }        
    }
}