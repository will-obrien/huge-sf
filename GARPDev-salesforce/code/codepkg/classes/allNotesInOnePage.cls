global class allNotesInOnePage {

    public allNotesInOnePage()
    {
            lstAccwrapper = new List<wrapper>();
        	lstAllAttachments = new List<wrapper>();
            garpId = ApexPages.currentPage().getParameters().get('GARPID');       
    }

    public String garpId{get;set;}
    global List<wrapper> lstAccwrapper {get; set;}
    public List<wrapper> lstAllAttachments {get; set;}
    Private List<Note> lstAccNotes {get; set;}
    Private List<Attachment> lstAccAttachments {get; set;}
    Private List<Attachment> lstConAttachments {get; set;}
    Private List<Attachment> lstOppAttachments {get; set;}
    Private List<Note> lstConNotes {get; set;}
    Private List<Note> lstOppNotes {get; set;}
    Private List<Note> lstAllNotes {get; set;}
    Private List<Account> lstacc;
    Private List<Contact> lstCon;
    Private List<Opportunity> lstOpp;
    Private map<id,string> mapOpp;
    Private set<ID> userIDs;
    global Map<ID, User> m;
    

    global class wrapper implements Comparable
    {
       global string type {get;set;}
       global string title {get;set;}
       global string body {get;set;}
       global dateTime LastModified {get;set;}
       global string relatedTo {get;set;}
       global string relatedToLink {get;set;}
       global string linkToNote {get;set;}
       global string CreatedBy {get;set;}
       global dateTime CreatedDate {get;set;}
      
        global Integer compareTo(Object ObjToCompare) {
            wrapper compareTow = (wrapper)ObjToCompare;
        	if (LastModified == compareTow.LastModified) return 0;
        	if (LastModified > compareTow.LastModified) return 1;
        	return -1;
        }
    }

    public void getAllNotes()
    {
        
        
        /* Get all notes from Account */
        
        lstacc = [SELECT id,name,(SELECT Id,Title,body,LastModifiedDate,CreatedById,ParentID,CreatedDate FROM Notes),(SELECT Id,Name,LastModifiedDate,CreatedById,ParentID,CreatedDate FROM Attachments)FROM Account WHERE GARP_ID__c =: garpId];
        if(lstacc.size()>0)
        {
            		userIDs = new set<ID>();
                    for(Account acc:lstacc)
                    {
                        
                        lstAccNotes = acc.Notes;
                        lstAccAttachments = acc.Attachments;
                    }
            
            		for(Note no: lstAccNotes)
                    {
                        	userIDs.add(no.CreatedById);
                    }
            		
            		for(Attachment at: lstAccAttachments)
                    {
                        	userIDs.add(at.CreatedById);
                    }
            
            		
            	m = new Map<ID, User>([SELECT Id, Name FROM User where ID in: userIDs]);
                         
                    if(lstAccNotes.size()>0)
                    {
                        getNotes(lstAccNotes,'Account');
                        
                    }
            		if(lstAccAttachments.size()>0)
                    {
                         getAttachments(lstAccAttachments,'Account');
                    }
         }           
        /* Get all notes from Contact */
        lstCon = [SELECT id,(SELECT Id,Title,body,LastModifiedDate,CreatedById,ParentID,CreatedDate FROM Notes),(SELECT Id,Name,LastModifiedDate,CreatedById,ParentID,CreatedDate FROM Attachments)FROM contact WHERE GARP_Member_ID__c =: garpId];
        if(lstCon.size()>0)
        {
					userIDs = new set<ID>();            
        			for(Contact con:lstCon)
                    {
                        lstConNotes = con.Notes;
                        lstConAttachments = con.Attachments;
                        
                    }
                    
                    for(Note no: lstConNotes)
                    {
                        userIDs.add(no.CreatedById);
                    }
            		
            		for(Attachment at: lstConAttachments)
                    {
                        	userIDs.add(at.CreatedById);
                    }
            
                    m = new Map<ID, User>([SELECT Id, Name FROM User where ID in: userIDs]);     
                    if(lstConNotes.size()>0)
                    {
                        getNotes(lstConNotes,'Contact');

                    }
            		if(lstConAttachments.size()>0)
                    {
                        getAttachments(lstConAttachments,'Contact');
                    }
        
        }
        /* Get all notes from Opportunity */
        
        mapOpp = new map<id,string>();
        lstOppNotes = new List<Note>();
        lstOppAttachments = new List<Attachment>();
        lstOpp = [SELECT id,Display_Invoice_Number__c,(SELECT Id,Title,body,LastModifiedDate,CreatedById,ParentID,CreatedDate FROM Notes),(SELECT Id,Name,LastModifiedDate,CreatedById,ParentID,CreatedDate FROM Attachments)FROM opportunity WHERE GARP_Member_ID__c =: garpId];
        if(lstOpp.size()>0)
        {
            		userIDs = new set<ID>();
                    for(opportunity Opp:lstOpp)
                    {
                        lstOppNotes.addAll(Opp.Notes);
                        lstOppAttachments.addAll(Opp.Attachments);
                        mapOpp.put(Opp.id,Opp.Display_Invoice_Number__c);
                    }
                     for(Note no: lstOppNotes)
                    {
                        userIDs.add(no.CreatedById);
                    }
            
            		for(Attachment at: lstOppAttachments)
                    {
                        userIDs.add(at.CreatedById);
                    }
            
                    m = new Map<ID, User>([SELECT Id, Name FROM User where ID in: userIDs]);
            
                    if(lstOppNotes.size()>0)
                    {
                        for(Note n: lstOppNotes)
                        {
                            wrapper w = new wrapper();
                            User us = new User();
                            w.type = 'Note';
                            w.title = n.title;
                            w.body = n.body;
                            w.relatedTo = mapOpp.get(n.ParentID);
                            w.relatedToLink = 'https://na2.salesforce.com/'+ n.ParentID;
                            w.LastModified = n.LastModifiedDate;
                            w.linkToNote = 'https://na2.salesforce.com/'+n.id;
                            us = m.get(n.CreatedById);
                            w.CreatedBy = us.name;
                            w.CreatedDate = n.CreatedDate;
                            lstAccwrapper.add(w);
                        }
                    }
            
            
            		 if(lstOppAttachments.size()>0)
                    {
                        for(Attachment n: lstOppAttachments)
                        {
                            wrapper w = new wrapper();
                            User us = new User();
                            w.type = 'Attachment';
                            w.title = n.name;
                            w.relatedTo = mapOpp.get(n.ParentID);
                            w.relatedToLink = 'https://na2.salesforce.com/'+ n.ParentID;
                            w.LastModified = n.LastModifiedDate;
                            w.linkToNote = 'https://na2.salesforce.com/'+n.id;
                            us = m.get(n.CreatedById);
                            w.CreatedBy = us.name;
                            w.CreatedDate = n.CreatedDate;
                            lstAllAttachments.add(w);
                        }
                    }
                    
        }           
        
        lstAccwrapper.sort();
        lstAllAttachments.sort();
        
    }  // End of getAllNotes()
    
    public void getNotes(List<Note> lstNotes,String relatedTo)
    {
        
		for(Note n: lstNotes)
        {
        					wrapper w = new wrapper();
            				User us = new User();
                            w.type = 'Note';
                            w.title = n.title;
                            w.body = n.body;
                            w.relatedTo = relatedTo;
                            w.relatedToLink = 'https://na2.salesforce.com/'+ n.ParentID;
                            w.LastModified = n.LastModifiedDate;
                            w.linkToNote = 'https://na2.salesforce.com/'+n.id;
                            us = m.get(n.CreatedById);
                            w.CreatedBy = us.name;
                            w.CreatedDate = n.CreatedDate;
                            lstAccwrapper.add(w);
        }
        
    }
    
    public void getAttachments(List<Attachment> lstAttachments,String relatedTo)
    {
        for(Attachment n: lstAttachments)
        {
                            wrapper w = new wrapper();
                            User us = new User();
                            w.type = 'Attachment';
                            w.title = n.name;
                            w.relatedTo = relatedTo;
                            w.relatedToLink = 'https://cs23.salesforce.com/'+ n.ParentID;
                            w.LastModified = n.LastModifiedDate;
                            w.linkToNote = 'https://cs23.salesforce.com/'+n.id;
                            us = m.get(n.CreatedById);
                            w.CreatedBy = us.name;
                            w.CreatedDate = n.CreatedDate;
                            lstAllAttachments.add(w);
         }
    }

}