/**
   @Author: Shashank Singhal
   @name: effortDetails
   @CreateDate: 12/20/2013
   @Description: This is an extension class for the VF page EstimateRequirements_Release. This class is used to 
                 sum up the estimates of each phase for the requests associated to a release record.
   @Version: 1.0
   @reference <Referenced program names>
**/
public class effortdetails 
{
    
    // Variable declaration used across the whole class
    // These are estimates for different phases
    public double requirementGatheringEstimate{get;set;} 
    public double sitEstimate{get;set;}
    public double butEstimate{get;set;}
    public double uatEstimate{get;set;}
    public double designEstimate{get;set;}
    public double traindepEstimate{get;set;}
    public double adaptEstimate{get;set;}
    public double totalEstimate{get;set;}
    
    // This variable will store the release from the page
    private Release__c release = new Release__c();
    
    /**
    *  This is the parameterised constructor for the Class. It fetches the Release__c record referenced in the URL 
    *  and fetches the Request__c associated to that Release__c and calculate the sum of the estimates for all the
    *  Requests. 
    *  @name: effortdetails
    *  @param: ApexPages.StandardController
    */
    public effortdetails(ApexPages.StandardController controller) {
    
        // Variable initialisation
		// estimates for all phases are set to zero.
        requirementGatheringEstimate = 0.0;
        sitEstimate = 0.0;
        butEstimate = 0.0;
        uatEstimate = 0.0;
        designEstimate = 0.0;
        traindepEstimate = 0.0;
        adaptEstimate = 0.0;
        totalEstimate = 0.0;
        
        // Get the release record referenced in the URL
        release = (Release__c)controller.getRecord();
        
        // Fetch the requests associated to the release and iterate over the list of requests
        for (Request__c currentRequest :[SELECT TotEst__c,Adapt__c, BUT__c, Des__c, Req__c,
        							 			SIT__c, TrnDep__c, UAT__c 
        						 		 FROM Request__c 
        						 		 WHERE Release__c=: release.Id] )
        {
		
            // Recalculate the individual estimate for all the requests
            requirementGatheringEstimate=requirementGatheringEstimate + currentRequest.Req__c;
            sitEstimate=sitEstimate + currentRequest.SIT__c;
            butEstimate=butEstimate + currentRequest.BUT__c;
            uatEstimate= uatEstimate + currentRequest.UAT__c;
            designEstimate = designEstimate + currentRequest.Des__c;
            traindepEstimate = traindepEstimate + currentRequest.TrnDep__c;
            adaptEstimate = adaptEstimate + currentRequest.Adapt__c;
            totalEstimate= totalEstimate + currentRequest.TotEst__c;
        }
    }
 }