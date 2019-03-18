public with sharing class TemplateBuilderProxy {
    public static List<Section> template = new List<Section>();
    public static List<Section> template2 = new List<Section>(); 
    public static String templateJSON { get; set; }
    public static String templateJSON2 { get; set; }
    public static String templateId { get; set; } 
    static {
    	templateId = 'TPL-001';
    	// server side sort...
    	Section sec1 = new Section('sec1', '1', 'Introduction', '<b>give it a try</b>', '');
        Section sec2 = new Section('sec2', '2', 'Criteria', 'evaluates your appetite', '60');
        List<Section> subSections1 = new List<Section>{
        	new Section('sec3', '2.1', 'Sub Criteria', 'sub criteria 1', '20'),
            new Section('sec4', '2.2', 'Sub Criteria', 'sub criteria 2', '40')
        };
        subSections1.sort();
        sec2.subSections = subSections1;
        
        Section sec3 = new Section('sec5', '3', 'Introduction', 'evaluates your healthness', '');
        Section sec4 = new Section('sec6', '4', 'Criteria', 'how are you feeling', '60');
        
        List<Section> subSections2 = new List<Section>{
            new Section('sec7', '4.1', 'Sub Criteria', 'good', '10'),
            new Section('sec8', '4.2', 'Sub Criteria', 'awesome', '20'),
            new Section('sec9', '4.3', 'Sub Criteria', 'terrific', '20')
        };
        subSections2.sort();
        sec4.subSections = subSections2;
        
        
        template.add(sec1);
        template.add(sec3);
        template.add(sec2);
        template.add(sec4);
        
        template.sort();
        
        templateJSON = JSON.serialize(template);
        
        template2.add(new Section('sec1', '1', 'Introduction', 'One', ''));
        template2.add(new Section('sec2', '2', 'Introduction', 'Two', ''));
        template2.add(new Section('sec3', '3', 'Introduction', 'Three', ''));
        template2.add(new Section('sec4', '4', 'Introduction', 'Four', ''));
        
        templateJSON2 = JSON.serialize(template2);
    }
    
    // collection#read
	@RemoteAction
	public static List<Section> fetchTemplate(String tplId){
		if(tplId == 'TPL-001')
            return template;
        if(tplId == 'TPL-002')
            return template2;
        else
            return null;
	}
	    
    // model#read 
    @RemoteAction
    public static Section findSection(String id) {        
        return null;        
    }
	
	// model#create
    @RemoteAction
    public static String createSection(Section s) {
    	system.debug(s);
    	return 'success';
    }
    
    // model#update
    @RemoteAction
    public static String updateSection(Section s) {        
        system.debug(s);
        return 'success';
    }
    
    // model#delete     
    @RemoteAction
    public static String deleteSection(Section s){    	
    	system.debug(s);
        return 'success';
    }
    
    @RemoteAction
    public static String testCall(String p1, String p2){      
        return p1 + '-' + p2;
    }
    
    /*
     * Inner class represent the data model for section     
     */
    class Section implements Comparable {
    	public String id    { get; set; } 
        public String idx   { get; set; }
        public String type  { get; set; }        
        public String score { get; set; }
        public String description { get; set; }
        public List<Section> subSections { get; set; }
        
        public Section(String id, String idx, String type, String description, String score){
        	this.id = id;
        	this.idx = idx;
        	this.type = type;
        	this.description = description;
        	this.score = score;        	
        }
        
        public Integer compareTo(Object compareTo) { 
        	Section other = (Section)compareTo;
            if (this.idx == other.idx) return 0;
            if (this.idx > other.idx) return 1;
            return -1;
        }
    }    
}