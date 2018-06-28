public with sharing class CSVParser {

	private static integer linesRead = 0;

	private String delim = ',';
  	private String[] buffer; 
  	private integer endOfFile;

  	public CSVParser(String data,integer skipStartLines){
    	this.buffer = (data == null ? new List<String>() : data.trim().split('\n'));
    	for(integer x = 0; x < skipStartLines - 1; x++){
    		this.readLine();
    	}
    	this.setEndOfFile(0);
    	system.debug('buffer size: ' + String.valueOf(this.buffer.size()));
  	}

  	public CSVParser(String data, String delim,integer skipStartLines){
    	this.buffer = (data == null ? new List<String>() : data.split('\n'));
    	this.delim = delim;
    	for(integer x = 0; x < skipStartLines - 1; x++){
    		this.readLine();
    	}
    	this.setEndOfFile(0);
  	}
  	
  	public void setEndOfFile(integer endOfFile){
  		this.endOfFile = endOfFile;
  	}

  	public String[] readLine(){
  		CSVParser.linesRead++;
  		system.debug('Lines Read: ' + String.valueOf(CSVParser.linesRead));
  		if(this.buffer.size() == this.endOfFile ) return null;
    	String line = this.buffer.remove(0);
    	String[] parts = new String[] {};
    	while(line != ''){
      		Integer next = 0;
      		if(line.startsWith('"')){
        		line = line.substring(1); // strip initial "
        		Integer quoteIndex = findQuote(line, 0);    // Look for closing " on same line
        		while(quoteIndex == -1){            //  not found, we must have a newline within a quoted token
        	 		if(buffer.size() == 0){
            			// EOT!
            			quoteIndex = line.length();
        	 		}else{
            			// grab the next line and look to see if closing " can be found
            			Integer skip = line.length();
            			line += '\n' + this.buffer.remove(0);
            			quoteIndex = findQuote(line, skip);
          			}
        		}
        		// we have a quoted token, advance to comma
        		next = quoteIndex + 1;
        		parts.add(line.substring(0, quoteIndex).replace('""', '"'));
        	}else{    // non-quoted token, token end is at delim
        		next = line.indexOf(this.delim, next);
        		if(next == -1)
          			next = line.length();
        		// NB in Substring, "endindex" is the index of the character AFTER the last index to get
        		parts.add(line.substring(0, next));
      		}
      		if(next == line.length() - 1)
      			// case of a terminating comma.
        		parts.add('');
      		line = next < line.length() ? line.substring(next+1) : '';
    	}
    	if(parts.size() == 0)
      		// empty string - we still want to return something...
      		parts.add('');
      	for(String s : parts){
      		system.debug('column: ' + s);
      	}
    	return parts;
  	}

  	static private Pattern quotePattern = Pattern.compile('(?<!")"(?!")');

  	//  -------------------------------------------------
  	//  Helper: findQuote - find next quote " in line
  	private Integer findQuote(String line, Integer skip){
   		Matcher m = quotePattern.matcher(line);
    	m.region(skip, m.regionEnd());
    	if(!m.find())
     		return -1;
    	return m.start();
  	}

}