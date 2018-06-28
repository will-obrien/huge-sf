global class WebcartIterator implements Iterator<Integer> { //WebcartHelper.webCartItemPayment

   list<Integer> wciList {get; set;} 
   //list<WebcartHelper.webCartItemPayment> wciList {get; set;} 
   integer i {get; set;} 
   
   //sequenceNumber should start at 0 and continue sequentially
   public WebcartIterator(integer sequenceNumber){//string webCartName, string reportName
   	   //wciList = new list<WebcartHelper.webCartItemPayment>();

       //string xmlBodyResponse = WebcartHelper.callWebCart(webCartName, reportName, true); //webcartHelper.TBL_SAVED_PAYMENTS
       //wciList = WebcartHelper.parseWebCartToList(xmlBodyResponse);
       //WebcartHelper.checkforRefreshTokenSaveNeeded(webCartName);
       wciList = new list<Integer>();
       wciList.add(sequenceNumber);
       //wciList = WebcartHelper.createBatchList(sequenceNumber);
   	      	                
       i = 0; 
   }   

   global boolean hasNext(){ 
       if(i >= wciList.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   global integer next(){     //WebcartHelper.webCartItemPayment
       if(i >= wciList.size()){
       		return null;
       } 
       i++; 
       return wciList[i-1]; 
   } 

}