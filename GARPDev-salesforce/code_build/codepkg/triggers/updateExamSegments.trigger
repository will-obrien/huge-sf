trigger updateExamSegments on Exam_Attempt__c (after insert, after delete, after update ) {
  list< Exam_Attempt__c > lstExamAttempts = new list< Exam_Attempt__c > () ;
  if(trigger.isDelete )
    lstExamAttempts = trigger.old;
  else
    lstExamAttempts = trigger.new;
    
  set< id > contactIDs = new set< id > () ;
  map< id, Exam_Attempt__c > ContactID2EA = new map< id, Exam_Attempt__c > () ;
  for( Exam_Attempt__c EA : lstExamAttempts) { 
    contactIDs.add( EA.member__c ) ;
    ContactID2EA.put( EA.member__c, EA ) ;
  }
  list<contact> contacts2Update = new list<contact> () ;
  for( contact c : [SELECT id, Recent_Exam__c FROM contact WHERE id IN:contactIDs] ) {
    if( trigger.isDelete ) 
      c.Recent_Exam__c = ContactID2EA.get( c.id ).Exam_Name__c+' Deleted' ;
    else
    if ( ContactID2EA.get( c.id ).Cancelled__c == TRUE)
      c.Recent_Exam__c = ContactID2EA.get( c.id ).Exam_Name__c+' Cancelled' ;
      else 
      if ( ContactID2EA.get( c.id ).Defered__c == 'Pending' ) 
        c.Recent_Exam__c = ContactID2EA.get( c.id ).Exam_Name__c+' Deferred' ;
        else 
        c.Recent_Exam__c = ContactID2EA.get( c.id ).Exam_Name__c ;
    contacts2Update.add( c ) ;
  }
  update contacts2Update ;
}