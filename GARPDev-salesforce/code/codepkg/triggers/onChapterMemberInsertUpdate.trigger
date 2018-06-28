trigger onChapterMemberInsertUpdate on Chapter_Member__c(after insert, after update, after delete) {

	List < Chapter_Member__c > ChapMem = new List < Chapter_Member__c > ();
	List < Id > conIds = new List < Id > ();
	List < Id > cn = new List < Id > ();
	Map < Id, string > PriChpMap = new Map < Id, string > (); //map primary chapter names
	Map < Id, string > SecChpMap = new Map < Id, string > (); //map secondary chapter names
	Map < Id, Boolean > PriMap = new Map < Id, Boolean > (); //map for primary chapter checbox
	Map < Id, Boolean > SecMap = new Map < Id, Boolean > (); //map for secondary chapter checkbox
	Map < Id, Boolean > dirMap = new Map < Id, Boolean > (); //chapter director checkbox
	Map < Id, Boolean > compMemMap = new Map < Id, Boolean > (); //complimentary membership checkbox

    
    Map < Id,Chapter_Member__c > ChapMap = new Map < Id, Chapter_Member__c > (); //map primary chapter names
    
    if(Trigger.IsDelete) {
        for (Chapter_Member__c c : Trigger.old) {
            cn.add(c.Contact__c);
        }                
    } else {

        for (Chapter_Member__c c : Trigger.new) {
            cn.add(c.Contact__c);
        }
        
    }
    
	list < Chapter_Member__c > cm = [select id, Contact__c, IsPrimary__c, IsSecondary__c, Director__c, Chapter__r.Name 
                                     from Chapter_Member__c where Contact__c in : cn];
    
    for (Chapter_Member__c c : cm) {
		
        if(c.Director__c)
        	dirMap.put(c.Contact__c, c.Director__c);
        
        if(c.IsPrimary__c) {
            PriMap.put(c.Contact__c, c.IsPrimary__c);           
            PriChpMap.put(c.Contact__c, c.Chapter__r.Name);
        } else {
            SecMap.put(c.Contact__c, c.IsSecondary__c);
            SecChpMap.put(c.Contact__c, c.Chapter__r.Name);
        }
    }
    
	List < Contact > cs = [SELECT Id, KPI_Chapter_Director__c, KPI_Primary_Chapter_Name__c, KPI_Secondary_Chapter_Name__c, KPI_Complementary_Membership__c,
							KPI_Chapter_Primary__c, KPI_Chapter_Secondary__c FROM Contact WHERE Id in : cn order by Id];
    
    for(Contact c : cs) {
        
        c.KPI_Chapter_Primary__c = false;
        c.KPI_Primary_Chapter_Name__c = null;
        c.KPI_Chapter_Secondary__c = false;
        c.KPI_Secondary_Chapter_Name__c = null;
        c.KPI_Chapter_Director__c = false;
        
        Boolean primary = PriMap.get(c.Id);
        if(primary != null) {
            c.KPI_Chapter_Primary__c = primary;
            if(primary != null && primary == true) {
                c.KPI_Primary_Chapter_Name__c = PriChpMap.get(c.Id);
            }
        }
        
        Boolean secondary = SecMap.get(c.Id);
        if(secondary != null) {
            c.KPI_Chapter_Secondary__c = secondary;
            if(secondary != null && secondary == true) {
                c.KPI_Secondary_Chapter_Name__c = SecChpMap.get(c.Id);
            }
        }

        Boolean dir = dirMap.get(c.Id);
        if(dir != null)
        	c.KPI_Chapter_Director__c = true;
        
    }
    update cs;
    
}