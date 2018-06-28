global with sharing class dashboardController {

	global dashboardController(){
		
	}

    public static string oppData {
    	
    	get {
		
		JSONGenerator j = JSON.createGenerator(false);
		j.writeStartArray();
		
		for(AggregateResult o : [SELECT StageName, SUM(Amount) amt, COUNT(Name) cnt FROM Opportunity WHERE CloseDate = THIS_YEAR GROUP BY ROLLUP(StageName)]){
						
			if(o.get('StageName') != null && o.get('amt') != null && o.get('cnt') != null){
				j.writeStartObject();
				j.writeObjectField('StageName', o.get('StageName'));
				j.writeObjectField('amt', o.get('amt'));
				j.writeObjectField('cnt', o.get('cnt'));						
				j.writeEndObject();
			}
			
		}
		
		j.writeEndArray();
		
		String oppJSON = j.getAsString();
			
        return oppJSON;
        
    	}
    	
    }

}