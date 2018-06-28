public with sharing class RuleValidator {
	
	private final static String PACKAGE_NS = 'UP2GO_ITE';
	private List<ValidationRule> rules;
	
	
	// CONSTRUCTOR
	
	public RuleValidator(RuleType ruleType) {
		rules = loadRules(ruleType);
	}
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		for(ValidationRule rule : rules) {
			rule.validate(records);
		}
	}
	
	
	// PRIVATE METHODS
	
	private List<ValidationRule> loadRules(RuleType currentType) {
		List<ValidationRule> results = new List<ValidationRule>();
		
		String settingsField = 'txt_' + currentType.name() + 'Classes__c';
		String settingsValue = (String) CustomSettings__c.getOrgDefaults().get(settingsField);
		List<String> fqClassNames = settingsValue.deleteWhitespace().split(',');
		
		for(String fqClassName : fqClassNames) {
			Type t = Type.forName(fqClassName);
					
			try {
				ValidationRule rule = (ValidationRule) t.newInstance();
				results.add(rule);
			}
			catch(Exception ignored) { /* ignore classes with Cast Exceptions */ }
		}
		
		return results;
	}
}