/**
 * Helper class provides helper methods to generated the order by clause for sorting.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class SortingHelper {
	
	/* Stores constant value for order by clause. */
	private static final String ORDER_BY_CLAUSE = ' ORDER BY ';
	
	/* Stores sort clause string. */
	private String sortClause;
	
	/**
	 * Constructor for the class, which takes the sort direction and sort expression as input
	 * and generated the sort clause to be used in the select query.
	 */
	public SortingHelper(String sortDirection, String sortExpression)
	{
		if (sortExpression != null)
		{
			sortClause = sortExpression;
			if (sortDirection != null)
			{
				sortClause = sortClause + PGIAppConstants.SPACE + sortDirection;
			}
			else
			{
				sortClause = sortClause + PGIAppConstants.SPACE + PGIAppConstants.SORT_DIRECTION_ASC;
			}
		}
	}
	
	/**
	 * Generates the order by clause using the sort clause to be used in select query.
	 *
	 * @returns genereated order by clause.
	 */
	public String getOrderByClause()
	{
		String orderByClause = '';
		if (this.sortClause != null)
		{
			orderByClause = ORDER_BY_CLAUSE + sortClause;
		}
		return orderByClause;
	}
}