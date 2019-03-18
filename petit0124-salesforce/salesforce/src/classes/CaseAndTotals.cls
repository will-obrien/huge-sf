/*******************************************************************
 * Wrapper class for the "Visualforce Report" recipe.
 * Encapsulates a Case and the number of records to that point with
 * the same status and origin.
 *******************************************************************/
public with sharing class CaseAndTotals {
   	public Case cs {get; set;}
   	public Integer statusTotal {get; set;}
   	public Integer originTotal {get; set;}

	public CaseAndTotals(Case inCs, Integer inStatusTotal, Integer inOriginTotal)
	{
		cs=inCs;
		statusTotal=inStatusTotal;
		originTotal=inOriginTotal;
	}    	
}