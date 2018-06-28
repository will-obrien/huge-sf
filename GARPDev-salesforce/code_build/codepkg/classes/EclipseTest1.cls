public class EclipseTest1 {
	public String name { get; set; }
	public String message {get; set; }
	public PageReference hello() {
		message = 'Hello, ' + name;
		return null;
	}
	public Survey__c survey { get; private set; }
	public EclipseTest1() {
		survey = [ SELECT Name, Description__c FROM Survey__c ];
	}
	public PageReference save() {
		message = 'Saved!';
		return null;
	}
}