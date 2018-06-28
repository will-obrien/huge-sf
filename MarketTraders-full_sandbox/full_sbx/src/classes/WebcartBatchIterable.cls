global class WebcartBatchIterable implements iterable<integer> { //WebcartHelper.webCartItemPayment

	//string webCartNameForIterator = '';
	//string webCartReportName = '';
	integer sequenceNumber = 0;

	global WebcartBatchIterable(integer sequenceNumberParam){ //string WebcartName, string reportName
		//webCartNameForIterator = WebcartName;
		//webCartReportName = reportName;
		sequenceNumber = sequenceNumberParam;
	} 

    global Iterator<integer> Iterator(){ //WebcartHelper.webCartItemPayment
       return new WebcartIterator(sequenceNumber); //webCartNameForIterator, webCartReportName
    }
}