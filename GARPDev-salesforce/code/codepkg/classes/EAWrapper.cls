global class EAWrapper implements Comparable {

    public Exam_Attempt__c ea;
    
    // Constructor
    public EAWrapper(Exam_Attempt__c e) {
        ea = e;
    }
    
    // Compare EAs based on their Section.
    global Integer compareTo(Object compareTo) {
        // Cast argument to EAWrapper
        EAWrapper compareToEA = (EAWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        integer returnValue = 0;
        system.debug('* * * In compareTo... calcPrecedence(ea.Ticket_Code__c)is.. '+calcPrecedence(ea.Ticket_Code__c));
        system.debug('* * * In compareTo... calcPrecedence(compareToEA.ea.Ticket_Code__c)is.. '+calcPrecedence(compareToEA.ea.Ticket_Code__c));
        if ( calcPrecedence(ea.Ticket_Code__c) > calcPrecedence(compareToEA.ea.Ticket_Code__c)) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (calcPrecedence(ea.Ticket_Code__c) < calcPrecedence(compareToEA.ea.Ticket_Code__c)) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        system.debug('* * * In compareTo... returnValue is.. '+returnValue);
        return returnValue;       
    }


  public integer calcPrecedence ( string tcode ) {
    Integer seatPrecedence = 99 ;
    if( tcode.startsWith( 'ERP-' )) seatPrecedence = 0 ;
    if( tcode.startsWith( 'FRM12' )) seatPrecedence = 1 ;
    if( tcode.startsWith( 'FRM1-' )) seatPrecedence = 2 ;
    if( tcode.startsWith( 'FRM2-' )) seatPrecedence = 3 ;
     system.debug('* * * In calcPrecedence... tcode is.. '+tcode+' and seatPrecedence is.. '+seatPrecedence);
    return ( seatPrecedence ) ;
  }       
}