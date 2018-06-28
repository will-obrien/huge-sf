global class hqInt_MainClass {

    private Integer offsetParameter;
    private CommcareToSalesforceSettings__c serverSettings;

    public hqInt_MainClass(CommcareToSalesforceSettings__c serverSettings) {

    }

    global void mainMethod(Integer offsetParameter, CommcareToSalesforceSettings__c serverSettings) {

    }

    /**
     * Method Name : requestMethod
     * Purpose : Http Callout to CommCareHQ
     **/
    public HTTPResponse requestMethod() {
        return null;
    }

    /**
     * Method Name : processJson
     * Purpose : Process Json response and perform DML 
     **/
    private void processJson(String jsonString) {

    }

    /**
     * Method Name : ReplaceReservedWords
     * Purpose : In json string, some fields will be reserved / not allowed keywords. This method will replace those with alternate names
     **/
    private string ReplaceReservedWords(String body) {
      return null;
    }
}