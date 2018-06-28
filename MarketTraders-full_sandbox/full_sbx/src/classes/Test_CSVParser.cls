/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_CSVParser {

        
	static testmethod void testSplitCsvSimple(){
    	String line = 'abc,efg';
    	String[] splitted = new CSVParser(line,1).readLine();
    	System.assertEquals(2, splitted.size());

   		System.assertEquals('efg', splitted[1]);
    	System.assertEquals('abc', splitted[0]);
  	}
	
	static testmethod void testSplitCsvEOL(){
	    String line = 'abc,';
	    String[] splitted = new CSVParser(line,1).readLine();
	    System.assertEquals(2, splitted.size());
	    
	    System.assertEquals('', splitted[1]);
		System.assertEquals('abc', splitted[0]);
	}
	
	static testmethod void testSplitCsvQuotedSimple(){
	    String line = '"abc,def"';
	    String[] splitted = new CSVParser(line,1).readLine();
	    System.assertEquals('abc,def', splitted[0]);
	}
	
	static testmethod void testSplitCsvQuoted(){
	    String line = '"abc,def",gh"i,"jk""l",""';
	    String[] splitted = new CSVParser(line,1).readLine();
	    System.assertEquals(4, splitted.size());
	    System.assertEquals('gh"i', splitted[1]);
	    System.assertEquals('abc,def', splitted[0]);
	    System.assertEquals('jk"l', splitted[2]);
	    System.assertEquals('', splitted[3]);
	}
	
	static testmethod void testSplitCsvQuotedWithNewLine(){
	    String line = '"abc,def\nBoo\nBoo",Test';
	    CSVParser reader = new CSVParser(line,1);
	    String[] splitted = reader.readLine();
	    System.assertEquals('abc,def\nBoo\nBoo', splitted[0]);
	    System.assertEquals('Test', splitted[1]);
	    System.assertEquals(null, reader.readLine());
	}
	
	static testmethod void testSplitCsvQuotedWithEOT(){
	    String line = '"abc,def\nBoo';
	    CSVParser reader = new CSVParser(line,1);
	    String[] splitted = reader.readLine();
	    System.assertEquals('abc,def\nBoo', splitted[0]);
	    System.assertEquals(null, reader.readLine());
	}
	  
	static testmethod void testTabDelim(){
	    String line = 'abc\tdef';
	    CSVParser reader = new CSVParser(line, '\t',1);
	    String[] splitted = reader.readLine();
	    System.assertEquals('abc', splitted[0]);
	}
	  
	static testmethod void testEmptyStrings(){
	    String line = ',,,,';
	    CSVParser reader = new CSVParser(line,1);
	    String[] splitted = reader.readLine();
	    System.assertEquals(5, splitted.size());
	    for(String s: splitted){
	    	System.assertEquals('', s);
		}
	}
	  
	  
	// make sure we still get a result even if the source is empty...
	static testmethod void testEmptyString(){
	    String line = '';
	    CSVParser reader = new CSVParser(line,1);
	    String[] splitted = reader.readLine();
	    System.assertEquals(1, splitted.size());
	    System.assertEquals('', splitted[0]);
	}
         
}