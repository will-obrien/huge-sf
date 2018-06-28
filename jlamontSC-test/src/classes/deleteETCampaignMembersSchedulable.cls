//public with sharing class deleteETCampaignMembersSchedulable {
global class deleteETCampaignMembersSchedulable implements Schedulable{
	
    global void execute(SchedulableContext sc){
    	
    	Date d = System.today() - 30;
    	
		//List<Opportunity> opportunities = [SELECT OwnerId, Amount, Probability FROM OPPORTUNITY 
		//	where Amount > 0 and LastModifiedDate < :d];
    	//CreatedBy = '005i0000005SiYqAAK'
		//CreatedDate < 2015-06-26T00:00:00.000Z
    	//String query = 'SELECT id FROM CampaignMember WHERE CreatedBy = AND CreatedDate != LAST_N_DAYS:30';
    	
        //String query = 'SELECT id FROM CampaignMember WHERE CampaignId = \'701i00000015Mi5\' AND Status = \'Attended\'';
        //String query = 'SELECT id FROM CampaignMember WHERE CreatedById = \'005i0000005SiYqAAK\' AND CreatedDate < :d';
        //String query = 'SELECT id FROM CampaignMember WHERE CreatedById = \'005i0000005SiYqAAK\' AND CreatedDate != LAST_N_DAYS:30';

		// VB: 8/6/15 - Added Brian Smith Fundraising campaign requirement clause
		/*
		String query = 'SELECT id ' + 
							'FROM CampaignMember ' +
							'WHERE CreatedById = \'005i0000005SiYqAAK\' ' + 
							'AND CreatedDate != LAST_N_DAYS:30 ' +
							'AND (' +
							'Campaign.RecordTypeId = \'012i0000000xbyx\' ' +
							'AND (NOT Campaign.Name like \'A%\') ' +
							'AND (NOT Campaign.Name like \'D%\') ' +
							'AND (NOT Campaign.Name like \'E%\') ' +
							'AND (NOT Campaign.Name like \'H%\') ' +
							'AND (NOT Campaign.Name like \'J%\') ' +
							'AND (NOT Campaign.Name like \'L%\') ' +
							'AND (NOT Campaign.Name like \'M%\') ' +
							'AND (NOT Campaign.Name like \'N%\') ' +
							'AND (NOT Campaign.Name like \'P%\') ' +
							'AND (NOT Campaign.Name like \'R%\') ' +
							'AND (NOT Campaign.Name like \'S%\') ' +
							'AND (NOT Campaign.Name like \'T%\') ' +
							'AND (NOT Campaign.Name like \'U%\') ' +
							'AND (NOT Campaign.Name like \'V%\') ' +
							'AND (NOT Campaign.Name like \'W%\') ' +
							'AND (NOT Campaign.Name like \'X%\') ' +
							'AND (NOT Campaign.Name like \'Z%\') ' +
							')';
		*/					
		String query = 'SELECT id ' +
						'FROM CampaignMember ' +
						'WHERE CreatedById = \'005i0000005SiYqAAK\' ' +
						'AND CreatedDate != LAST_N_DAYS:30 ' +
						'AND (' +
						'(Campaign.RecordTypeId = \'012i0000000xbyx\' ' +
						'AND (NOT Campaign.Name like \'A%\') ' +
						'AND (NOT Campaign.Name like \'D%\') ' +
						'AND (NOT Campaign.Name like \'E%\') ' +
						'AND (NOT Campaign.Name like \'H%\') ' +
						'AND (NOT Campaign.Name like \'J%\') ' +
						'AND (NOT Campaign.Name like \'L%\') ' +
						'AND (NOT Campaign.Name like \'M%\') ' +
						'AND (NOT Campaign.Name like \'N%\') ' +
						'AND (NOT Campaign.Name like \'P%\') ' +
						'AND (NOT Campaign.Name like \'R%\') ' +
						'AND (NOT Campaign.Name like \'S%\') ' +
						'AND (NOT Campaign.Name like \'T%\') ' +
						'AND (NOT Campaign.Name like \'U%\') ' +
						'AND (NOT Campaign.Name like \'V%\') ' +
						'AND (NOT Campaign.Name like \'W%\') ' +
						'AND (NOT Campaign.Name like \'X%\') ' +
						'AND (NOT Campaign.Name like \'Z%\'))' +
						'OR Campaign.RecordTypeId != \'012i0000000xbyx\'' +
						')';
        
        deleteETCampaignMembers delBatch = new deleteETCampaignMembers(query);
        Id BatchProcessId = Database.ExecuteBatch(delBatch);
    }
}