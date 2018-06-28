trigger leadDupeDel on Lead (before insert,before update) {
    for (Lead dup : Trigger.new) {
        if (dup!=Null) {
            List<Contact> conDup =[Select id from Contact where Email=:dup.Email];
            if (conDup.size()>0){
            String erromsg = 'There is duplicate contact exist with ID '+ conDup[0];
            dup.addError(erromsg);
         	}
        }
        
    }
    
}