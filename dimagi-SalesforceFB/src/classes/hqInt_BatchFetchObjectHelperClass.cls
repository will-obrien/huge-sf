public class hqInt_BatchFetchObjectHelperClass {

    public Integer fetchTotalCount(Integer offset, String objectUrl, Integer apiLimitParameter,String dateModifiedParam) {
        return 0;
    }

    /**
     * 
     * Method Name : fetchAndInsertRecords  
     * Purpose : 
     * 
     **/
    public Integer fetchAndInsertRecords(Integer offset, String objectUrl, Integer apiLimitParameter, String dateModifiedParam) {
        return 0;
    }

    /**
     * 
     * Method Name : requestMethod  
     * Purpose : Http Callout to CommCareHQ 
     * 
     **/
    public HTTPResponse requestMethod(Integer offset,String objectUrl,Integer apiLimitParameter,String dateModifiedParam) {
        return null;
    }

    private Integer processJson(String jsonString, String objectUrl) {
        return null;
    }

    private String replaceReservedWords(String myString) {
       return null;
    }

    public String generateEndPointUrl(Integer offsetParam,String objectUrl,  Integer limitParam, String dateModifiedParam) {        return null;
    }

     public static void runNextBatch(Integer batchToBeRun) {
        /**Boolean lastBatch=false;
        //Before running batches, initialize the job start date
        if(!test.isRunningTest() && batchToBeRun == 1) {
            CommcareToSalesforceSettings__c jobStartDateSetting = CommcareToSalesforceSettings__c.getInstance('JOBSTARTDATE');
            jobStartDateSetting.Value__c = System.now().format('yyyy-MM-dd');
            update jobStartDateSetting;
        }

        //if(batchToBeRun == 1) Database.executeBatch(new hqInt_BatchFetchObjectLineItem(batchToBeRun),1);
        //if(batchToBeRun == 2) Database.executeBatch(new hqInt_BatchFetchObjectCreditAdjustment(batchToBeRun),1);
        //if(batchToBeRun == 3) Database.executeBatch(new hqInt_BatchFetchObjectPaymentRec(batchToBeRun),1);
        //if(batchToBeRun == 1) Database.executeBatch(new hqInt_BatchFetchObjectAcctingInvoice(batchToBeRun),1);
          

        if(batchToBeRun == 1) {
            Database.executeBatch(new hqInt_BatchFetchObjectFeature(batchToBeRun),1);
            //if(batchToBeRun == 2)
            //Database.executeBatch(new hqInt_BatchFetchObjectBillingAccAdmin(batchToBeRun),1);
        } else if (batchToBeRun == 2) {
            Database.executeBatch(new hqInt_BatchFetchObjectSoftwarePlan(batchToBeRun),1);
        } else if (batchToBeRun == 3) {
            Database.executeBatch(new hqInt_BatchFetchObjectSubscriber(batchToBeRun),1);
        } else if (batchToBeRun == 4) {
            Database.executeBatch(new hqInt_BatchFetchObjectFeatureRate(batchToBeRun),1);
        } else if (batchToBeRun == 5) {
            Database.executeBatch(new hqInt_BatchFetchObjectProductRate(batchToBeRun),1);
        } else if (batchToBeRun == 6) {
            Database.executeBatch(new hqInt_BatchFetchObjectSoftwarePlanVer(batchToBeRun),1);
        } else if (batchToBeRun == 7) {
            Database.executeBatch(new hqInt_BatchFetchObjectPaymentMethod(batchToBeRun),1);
        } else if (batchToBeRun == 8) {
            Database.executeBatch(new hqInt_BatchFetchObjectBillingContactInfo(batchToBeRun),1);
        } else if (batchToBeRun == 9) {
            Database.executeBatch(new hqInt_BatchFetchObjectPaymentRec(batchToBeRun),1);
        } else if (batchToBeRun == 10) {
            Database.executeBatch(new hqInt_BatchFetchObjectBillingAccount(batchToBeRun),1);
        } else if (batchToBeRun == 11) {
            Database.executeBatch(new hqInt_BatchFetchObjectSubscription(batchToBeRun),1);
        } else if (batchToBeRun == 12) {
            Database.executeBatch(new hqInt_BatchFetchObjectAcctingInvoice(batchToBeRun),1);
        } else if (batchToBeRun == 13) {
            Database.executeBatch(new hqInt_BatchFetchObjectLineItem(batchToBeRun),1);
        } else if (batchToBeRun == 14) {
            Database.executeBatch(new hqInt_BatchFetchObjectSubcriptionAdj(batchToBeRun),1);
        } else if (batchToBeRun == 15) {
            Database.executeBatch(new hqInt_BatchFetchObjectCreditLine(batchToBeRun),1);
        } else if (batchToBeRun == 16) {
            Database.executeBatch(new hqInt_BatchFetchObjectCreditAdjustment(batchToBeRun),1);
            lastBatch = true;
        }

        if (lastBatch) {
            CommcareToSalesforceSettings__c lastRunDateSetting = CommcareToSalesforceSettings__c.getInstance('LastRunDate');
            CommcareToSalesforceSettings__c jobStartDateSetting = CommcareToSalesforceSettings__c.getInstance('JOBSTARTDATE');
            lastRunDateSetting.Value__c = jobStartDateSetting.Value__c;
            Database.executeBatch(new CalculateDomainsLifeTimeMRRBatch(), 100);
            update lastRunDateSetting;
        }*/
     }
}