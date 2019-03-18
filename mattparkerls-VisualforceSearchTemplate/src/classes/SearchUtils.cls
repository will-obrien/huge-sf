public virtual class SearchUtils {

	public String searchText {get; set;}
	public List<Contact> contacts {get; set;}
	public Boolean showError {get; set;}
	public String errorMsg {get; set;}
	public String JSONString {get; set;}

    public virtual PageReference reset(){
        showError = false;
        return null;
    }

	public virtual PageReference search(){

		reset();

		if(searchText != null){
			if(searchText.length() >= 2){
				if(searchText.isAlphaSpace()){
        			contacts = database.query(queryString());
	        	}
	        	else{
	        		errorMsg = 'You must only use letters';
	        		showError = true;
	        		return null;
	        	}
			}
			else{
				errorMsg = 'You must enter at least 2 characters';
				showError = true;
				return null;
			}
    	}

        return null;
	}

	private String queryString(){

		String q;
		String text = String.escapeSingleQuotes(searchText).toLowerCase();
		String first = text.substringBefore(' ');
		String last = text.substringAfter(' ');

		q = 'select id,firstname,lastname,email from Contact where ';
		q+= 'lastname LIKE \'%' + text + '%\' ';
		q+=  'OR firstname LIKE \'%' + text + '%\'';
		q+=  'OR ';
		q+= '(firstname LIKE \'%' + first + '%\'';
		q+=  'AND lastname LIKE \'%' + last + '%\')';

		return q;
	}

	public virtual PageReference getNames(){
		stringToJSON();
		return null;
	}

	private List<String> findFullNames(){
		Contact[] contList = [select id,firstname,lastname,email from Contact]; //Limit this query if more than 50K contacts are in system
		list<String> fullnames = new list<String>();

		for(Contact c : contList){
			if(c.firstname != null)
			fullnames.add(c.firstname+' '+c.lastname);
		}

		return fullnames;
	}

	private void stringToJSON(){
		JSONString = JSON.serialize(findFullNames());
	}
}