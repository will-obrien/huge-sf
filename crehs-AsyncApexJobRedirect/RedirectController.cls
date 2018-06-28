public class RedirectController {
	
    private String pid {get;set;}
    private Map<String,String> pageParameters {get;set;}
    private PageReference redirect {get;set;}
    public Boolean polling {get;set;}
			
	public RedirectController(){

		//get page param map
		this.pageParameters = ApexPages.currentPage().getParameters();
		
		//get the pid from the url
		this.pid = pageParameters.get('pid');

		//retrieve the return url
		this.redirect = new PageReference( '/' + pageParameters.get('redirect') );

		//explicitly turn polling off via page param for debugging purposes
		this.polling = ( String.isNotBlank( pageParameters.get('polling') ) && Boolean.valueOf( pageParameters.get('polling') ) == false ) ? false : true; 

	}

	//method to be called from the action poller on the page
    public PageReference checkApexJobProcess() {
        
        /*redirects to the passed in url or stays if the job
        has not completed processing*/
        return hasJobProcessed() ? redirect : null;
    }

    /*method responsible for finding out if the apex job has completed*/
    private Boolean hasJobProcessed(){

    	List<AsyncApexJob> job = queryAsyncJob();

    	Boolean hasProcessed = false;

    	//if there's no job or the job has completed, failed, or aborted
    	if( job.size() == 0 || ( job.size() > 0 && ( job[0].Status == 'Aborted' || job[0].Status == 'Completed' || job[0].Status == 'Failed' ) ) )
    		hasProcessed = true;

    	return hasProcessed;

    }

    //query the AsyncApexJob with the passed in pid
    private List<AsyncApexJob> queryAsyncJob(){
		
		return [ SELECT Id, Status FROM AsyncApexJob WHERE Id =: pid ];

    }

}
