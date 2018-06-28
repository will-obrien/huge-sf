/**
   @Author - Shashank Singhal
   
   @name - UpdateReleaseLOE_HelperClass
   
   @CreateDate - 01/27/2014
   
   @Description - Helper class to create update the estimates on Release for which an associated Request is inserted, updated or Deleted
                  
   @Version - 1.0
   
   @reference - None
  */
public class UpdateReleaseLOE_HelperClass{

    // Variable declaration
    private static double requirementEstimate;
    private static double sitEstimate;
    private static double butEstimate;
    private static double uatEstimate;
    private static double designEstimate;
    private static double deployEstimate;
    private static double adaptEstimate;
    
    /**
    *  Description -  This method is a helper function to reset the values of the class variables
    *
    *  @name - resetValues
    *
    *  @param - None
    *
    *  @return - None
    *
    *  @throws exception- None
    */
    public static void resetValues()
    {
    
        // resetting the estimates for different phases to zero
        requirementEstimate=0.0;
        sitEstimate=0.0;
        butEstimate=0.0;
        uatEstimate=0.0;
        designEstimate=0.0;
        deployEstimate=0.0;
        adaptEstimate=0.0;
    }
    
    /**
    *  Description -  This method loops over the requests that are inserted, updated or deleted and create a set of the parent release.
                      Then aggregate the LOE values of the requests associated to these Releases and copy the same to the respective release.
                      This is a helper class for trigger UpdateReleaseLOEOnRequestChange
    *
    *  @name - updateRelease
    *
    *  @param - List<Request__c> requestToProcess - Contains the Requests coming from the trigger
    *
    *  @return - None
    *
    *  @throws exception- None
    */
    public static void updateRelease(List<Request__c> requestToProcess)
    {
        Set<string> releaseSet = new set<string>();
        List<Release__c> releaseToUpdateList = new List<Release__c>();
        
        try
        {
            // Iterate over the Requests coming from the trigger
            for(Request__c currentRequest : requestToProcess)
            {
                // add the Ids of the parent Release to a set
                releaseSet.add(currentRequest.Release__c);
            }
            
            // Fetch the requests related to the Release in the set
            for (Release__c currentRelease : [SELECT Id, Requirements_Gathering__c, Design__c, Build_Unit_Test__c,
                                                	 PMT2009_SIT__c, PMT2009_UAT__c, PMT2009_Train_Deploy__c, 
                                                     Adapt_Ongoing_Support__c,
                                                     (SELECT Id, Req__c, Des__c, BUT__c, SIT__c, UAT__c, 
                                                             TrnDep__c, Adapt__c 
                                                      FROM Requirements__r) 
                                              FROM Release__c 
                                              WHERE id IN : releaseSet ])
            {
            
                // Reset the class variables
                resetValues();
                
                // Iterate over the associated Requests
                for (Request__c currentRequest : currentRelease.Requirements__r)
                {
                    // Aggregate the individual estimates
                    requirementEstimate = requirementEstimate + currentRequest.Req__c;
                    sitEstimate = sitEstimate + currentRequest.SIT__c;
                    butEstimate = butEstimate + currentRequest.BUT__c;
                    uatEstimate = uatEstimate + currentRequest.UAT__c;
                    designEstimate = designEstimate + currentRequest.Des__c;
                    deployEstimate = deployEstimate + currentRequest.TrnDep__c;
                    adaptEstimate = adaptEstimate + currentRequest.Adapt__c;
                }
                
                // Copy values to the individual estimates
                currentRelease.Requirements_Gathering__c = requirementEstimate;
                currentRelease.Design__c = designEstimate;
                currentRelease.Build_Unit_Test__c = butEstimate;
                currentRelease.PMT2009_SIT__c = sitEstimate;
                currentRelease.PMT2009_UAT__c = uatEstimate;
                currentRelease.PMT2009_Train_Deploy__c = deployEstimate;
                currentRelease.Adapt_Ongoing_Support__c = adaptEstimate;
                
                // Add to release to update list for updating
                releaseToUpdateList.add(currentRelease);
                

            }
            
            // update only if releaseToUpdateList is empty
            if (!releaseToUpdateList.isEmpty())
            {
                // Update the Release
                update releaseToUpdateList;
            }
        }
        
        catch(Exception ex)
        {
            ex.setMessage(system.label.PMO_Task_Error);
        }
     }
}