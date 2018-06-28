public class DispatcherCaseNewController {

    // Staff - Advancement/IT Cases
    // fullCircle - rC support Cases
    // Constituent - External Client/Constituent/AddUP Cases
    static Id caseTypeStaffId;
    static Id caseTypeFullCircleId;
    static Id caseTypeConstituentId;
    
    static {
		//System.debug('---Static:S---');
        caseTypeStaffId         = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CORE').getRecordTypeId();
        caseTypeFullCircleId    = Schema.SObjectType.Case.getRecordTypeInfosByName().get('fullCircle').getRecordTypeId();
        caseTypeConstituentId   = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Constituent').getRecordTypeId();
		System.debug('CORE:' + caseTypeStaffId);
		System.debug('fullCircle:' + caseTypeFullCircleId);
		System.debug('Constituent:' + caseTypeConstituentId);
    }
    
    public DispatcherCaseNewController(ApexPages.StandardController controller) {
		//System.debug('---Start---');
        this.controller = controller;
    }

    public PageReference getRedir() {
		//System.debug('---Start:redir---');
        PageReference newPage;

        // If the Case is a Staff recordType
        if (ApexPages.currentPage().getParameters().get('RecordType') == caseTypeStaffId) {
            
            // Redirect to the custom Staff Case page
            newPage = Page.CaseStaffCreate;
            return newPage.setRedirect(true);
        //} else if (ApexPages.currentPage().getParameters().get('RecordType') == caseTypeConstituentId){
        //    // Redirect to the custom Staff Case page
        //    newPage = Page.CaseStaffCreate;
        //    return newPage.setRedirect(true);
        } else {
            // Prevent the redirect back to the Record Type Selection page?
            //newPage = newPageReference('/' + idOfCurrentRec + '/e')
            newPage = new PageReference('/500/e?RecordType=' + ApexPages.currentPage().getParameters().get('RecordType'));
            //newPage = new PageReference(URLFOR(ApexPages.currentPage()));
            //newPage = new PageReference('/500/e?retURL=%2F500%2Fo');
            newPage.getParameters().put('nooverride', '1');
            //return null;  // redirect to the Standard Controller page ( i think )
            return newPage.setRedirect(true);   // redirect to the Standard Controller page ( i think )
        }

    }
    private final ApexPages.StandardController controller;
}