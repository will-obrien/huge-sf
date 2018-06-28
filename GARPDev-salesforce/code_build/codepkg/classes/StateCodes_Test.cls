@istest

public class StateCodes_Test {

    static  testMethod void  UnitTest_1(){
        
 
        string[] str1 = new string []{   'Alberta',
							             'British Columbia',
							             'Manitoba',
							             'New Brunswick',
							             'Newfoundland',
							             'Northwest Territories',
							             'Nova Scotia',
							             'Nunavut',
							             'Ontario',
							             'Prince Edward Island',
							             'Quebec',
							             'Saskatchewan',
							             'Yukon Territory'};
        for(string str : str1){
        	StateCodes.getStateId( 'Canada',str);
		}

		string [] str2 = new string [] {
	'Alabama',
	'Alaska',
	'Arizona',
	'Arkansas',
	'California',
	'Colorado',
	'Connecticut',
	'Delaware',
	'District of Columbia',
	'Florida',
	'Georgia',
	'Hawaii',
	'Idaho',
	'Illinois',
	'Indiana',
	'Iowa',
	'Kansas',
	'Kentucky',
	'Louisiana',
	'Maine',
	'Maryland',
	'Massachusetts',
	'Michigan',
	'Mississippi',
	'Missouri',
	'Montana',
	'Nebraska',
	'Nevada',
	'New Hampshire',

	'New Jersey',
	'New Mexico',
	'New York',
	'North Carolina',
	'North Dakota',
	'Ohio',
	'Oklahoma',
	'Oregon',
	'Pennsylvania',
	'Rhode Island',
	'South Carolina',
	'South Dakota',
	'Tennessee',
	'Texas',
	'Utah',
	'Vermont',
	'Virginia',
	'Washington',
	'West Virginia',
	'Wisconsin',
	'Wyoming'};

		for(string str : str2){
        	StateCodes.getStateId( 'US',str);
		}

        StateCodes.getStateId( 'US','MP');
            
        
    }
    
}