trigger HelloWorldLeadtrigger on Lead (before insert) {
	HelloWorldLeadClass.helloWorld(Trigger.new);
}