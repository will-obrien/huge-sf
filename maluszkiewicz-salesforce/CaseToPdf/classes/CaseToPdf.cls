public class CaseToPdf {
    public PageReference save() {
        return null;
    }

    public String inputDate {
        get; set;
    }
    
    public String errorMsg {
        get; set;
    }

    public String getCaseID() {
        return ApexPages.currentPage().getParameters().get('caseID');
    }

    public PageReference generate() {
    
        if(getCaseID()!=NULL && inputDate!=NULL) {
        
            try {
                Date toCheck = Date.parse(inputDate);
                return new PageReference('/apex/generated?caseID=' + getCaseID()+'&activityDate='+inputDate);
            } catch (TypeException e) {
                errorMsg = 'Please provide proper data...';
                return NULL;
            }
        } else {
            return NULL;
        }
    }
}