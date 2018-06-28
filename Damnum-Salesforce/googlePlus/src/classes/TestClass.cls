public with sharing class TestClass {
	public TestClass(){
		daOrder = new Order__c();
	}
	
	private Order__c daOrder;
	
    public PageReference save() {
    	daOrder.Name = firstname + surname;
        upsert daOrder;
        return null;
    }
	
	        // Properties for use in the Visualforce view
        public String firstname {
            get { return daOrder.Firstname__c; }
            set { daOrder.Firstname__c = value; }
        }
        public String surname {
        	 get { return daOrder.Surname__c;  }
        	 set { daOrder.Surname__c = value; }
        }
       
        public String email { 
        	get { return daOrder.Email__c;  }
        	set { daOrder.Email__c = value; }
        }

}