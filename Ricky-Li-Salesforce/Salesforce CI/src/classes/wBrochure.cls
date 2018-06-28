public with sharing class wBrochure {
	public Brochure__c Brochure {get; set;}
	public string sQty {get;set;}
    
    public wBrochure(Brochure__c b) {
        Brochure = b;
        sQty = '0';
    }
    
    public integer Qty
    {
    	get{
    		return integer.valueOf(sQty);			
    	}
    	set;
    }
    
    public static testMethod void testMe ()
    {
    	Brochure__c b = new Brochure__c();
    	wBrochure wB = new wBrochure(b);
    	System.assertEquals(0, wB.Qty);
    	wB.sQty = '5';
    	System.assertEquals(5, wB.Qty);
    	
    }
}