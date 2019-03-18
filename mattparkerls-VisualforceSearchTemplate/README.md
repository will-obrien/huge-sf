Visualforce page with a first and/or last name search across Contacts.  Typeahead.js uses a JSON string of Contact names, while the apex controller extends a virtual class with reusable search methods.

![Screen Shot]
(https://raw.githubusercontent.com/mattparkerls/VisualforceSearchTemplate/master/complete.png)

Entire controller is only 3 lines

```java
public class DeveloperController extends SearchUtils{
	public DeveloperController(){}
}
```

Query string handles SOQL injection and you can search by first,last, or full name
```java
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
```

Error handling for user input less than 1 character or non-alpha characters.

![Screen Shot]
(https://raw.githubusercontent.com/mattparkerls/VisualforceSearchTemplate/master/error.png)
