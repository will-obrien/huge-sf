global class deleteBUContactAddressesSchedulable implements Schedulable{
	
    global void execute(SchedulableContext sc){
    	
		// VB: 8/20/15 - Delete All Contact Addresses created by BatchUpload user.
						//'WHERE CreatedById = \'005i00000066uf9AAA\' ' +
 						// 'OR CreatedById = \'00519000000X3tf\'' // Full Sandbox User
		String query = 'SELECT id ' +
						'FROM rC_Bios__Contact_Address__c ' +
						'WHERE CreatedById = \'005i00000066uf9\''; 
        
        deleteBUContactAddresses delBatch = new deleteBUContactAddresses(query);
        Id BatchProcessId = Database.ExecuteBatch(delBatch);
    }
}