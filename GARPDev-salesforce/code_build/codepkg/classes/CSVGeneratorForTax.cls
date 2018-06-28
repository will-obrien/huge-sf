public class CSVGeneratorForTax
{
     //GARP_Invoice_Number__c,Shipping_Country__c,
     public string strHeader{get;set;}
     public string strRefundHeader{get;set;}
     public List<reportWrapper> lstRefundWrapper{get;set;}
    //public List<String> lstProdCodes = new List<String>();
    //public Map<String,objPriceBook>  mapProductDetails = new Map<String,objPriceBook>();
    public List<reportWrapper> lstWrapper{get;set;}
    public String strTest{get;set;}
    public Date dtStartDate;
    public Date dtEndDate;
    public boolean bIsTax;
    public boolean bIsRegular;
    Set<String> setProductCodes = new Set<String>();
    public CSVGeneratorForTax()
    {
        dtStartDate = Date.valueOf(ApexPages.currentPage().getParameters().get('stDate'));
        dtEndDate = Date.valueOf(ApexPages.currentPage().getParameters().get('endDate'));
         bIsTax = Boolean.valueOf(ApexPages.currentPage().getParameters().get('Taxable'));
        bIsRegular = Boolean.valueOf(ApexPages.currentPage().getParameters().get('Regular'));
        prepareHeader();
        prepareWrapper();
        strTest = 'TESTVAL,TESTVAL1';
        
        prepareRefundHeader();
    }
    
    public void prepareRefundHeader()
    {

        strRefundHeader = 'FRM1,FRM1E,FRM1H,FRM1L,FRM2E,FRM2H,FRM2L,MEMF,MEMI,SHIP,SLSTX';
        
        loadRefundData();
    }
    
    public void loadRefundData()
    {
         List<Product_Refunds__c> lstProdRefunds = [select Product_Code__c,Payment_Transaction__c,Product__c,Reason__c,Refund_amount__c,Refund_Code__c from Product_Refunds__c where Payment_Transaction__r.ChargentSFA__Opportunity__r.CloseDate >=: dtStartDate and Payment_Transaction__r.ChargentSFA__Opportunity__r.CloseDate <=: dtEndDate];
        //strRefundColumns = '';
        lstRefundWrapper = new List<reportWrapper>();
        for(Product_Refunds__c objRefund : lstProdRefunds) 
        {
             reportWrapper objReportDetails = new reportWrapper();
            if(objRefund.Product_Code__c == 'FRM1')
                objReportDetails.FRM1RefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'FRM1E')
                objReportDetails.FRM1ERefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'FRM1H')
                objReportDetails.FRM1HRefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'FRM1L')
                objReportDetails.FRM1LRefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'FRM2E')
                objReportDetails.FRM2ERefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'FRM2H')
                objReportDetails.FRM2HRefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'FRM2L')
                objReportDetails.FRM2LRefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'MEMF')
                objReportDetails.MEMFRefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'MEMI')
                objReportDetails.MEMIRefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'SHIP')
                objReportDetails.SHIPRefundAmt = objRefund.Refund_amount__c;
            if(objRefund.Product_Code__c == 'SLSTX')
                objReportDetails.SLSTXRefundAmt = objRefund.Refund_amount__c;
            
            lstRefundWrapper.add(objReportDetails);
        }
        
    }
    
    public void prepareHeader()
    {
        strHeader = '';
        strHeader = 'Purchase No,GARPID,Currency,Date Paid,Date of Purchase,Online Paynumber,Shipping Info';
        String strProdCodes = '';
        String strQuery = 'select unitprice,productcode,product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and isActive = true ';
        if(bIsTax)
           
        for(PriceBookEntry objPriceBook : Database.Query(strQuery)) 
        {
            if(strProdCodes != '') strProdCodes += ',';
            strProdCodes += objPriceBook.productcode;
            setProductCodes.add(objPriceBook.productcode);
        }
       
       strHeader += ',' + strProdCodes;
           
    }
    
    public void getData()
    {
        prepareHeader();
        prepareWrapper();
    }
  
    private void prepareWrapper()
    {
       system.debug('dtStartDate == '+dtStartDate + ' and dtEndDate == '+dtEndDate);
        lstWrapper = new List<reportWrapper>();
         Map<Id,ChargentSFA__Transaction__c> mapPayments = new Map<Id,ChargentSFA__Transaction__c>();
        for(ChargentSFA__Transaction__c objPay :  [select id,ChargentSFA__Tokenization__c,ChargentSFA__Payment_Method__c,ChargentSFA__Opportunity__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c  in : [select id FROM Opportunity where  CloseDate >=: dtStartDate and CloseDate <=: dtEndDate ] and ChargentSFA__Type__c = 'Charge' and ChargentSFA__Response_Status__c = 'Approved'])
        {
                mapPayments.put(objPay.Id,objPay);
        }
        Map<Opportunity,reportWrapper> mapOppWrapper = new Map<Opportunity,reportWrapper>();
        for(Opportunity objOpp : [SELECT Amount, Id, Display_Invoice_Number__c,CreatedDate,Shipping_City__c,Shipping_Country__c,Has_Books__c,CloseDate,GARP_Invoice_Number__c,Name, (SELECT Quantity, ListPrice,UnitPrice,PriceBookEntry.UnitPrice, PricebookEntry.Name,
                                  PricebookEntry.product2.Family,PricebookEntry.productCode,PricebookEntry.product2.GL_CODE__C FROM OpportunityLineItems where PricebookEntry.productCode in: setProductCodes) FROM Opportunity where CloseDate >=: dtStartDate and CloseDate <=: dtEndDate])
            {
                reportWrapper objReportDetails = new reportWrapper();
                objReportDetails.opp = objOpp;
                objReportDetails.payment = mapPayments.get(objOpp.Id);
                if(objOpp.Has_Books__c)
                {
                    objReportDetails.strShippingInfo = objOpp.Shipping_City__c + '-' +objOpp.Shipping_Country__c;
                }
                //String strVariableName= '';
                for(OpportunityLineItem objLineItem : objOpp.OpportunityLineItems)
                {
                    if(objLineItem.PricebookEntry.productCode == 'AFREE4' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                        objReportDetails.AFREE4999Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CBR' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                        objReportDetails.CBR4000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CBR2A' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                        objReportDetails.CBR2A4000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CBREL' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                        objReportDetails.CBREL4000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CBRHB' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.CBRHB4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CBRHI' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.CBRHI4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CBRNM' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                        objReportDetails.CBRNM4000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CHMT1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                        objReportDetails.CHMT14070Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CMCNY' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                        objReportDetails.CMCNY4070Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CMCNY' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.CMCNY4060Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CNY13' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.CNY134060Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CNY13' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                        objReportDetails.CNY134070Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CRF' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.CRF4060Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CRF' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                        objReportDetails.CRF4070Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'CRFA' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                        objReportDetails.CRFA4070Amount = objLineItem.UnitPrice;    
                    if(objLineItem.PricebookEntry.productCode == 'CRFA' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.CRFA4060Amount = objLineItem.UnitPrice;    
                    if(objLineItem.PricebookEntry.productCode == 'CRT' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                        objReportDetails.CRT4070Amount = objLineItem.UnitPrice; 
                    if(objLineItem.PricebookEntry.productCode == 'CRT' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.CRT4060Amount = objLineItem.UnitPrice; 
                    if(objLineItem.PricebookEntry.productCode == 'CRT' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.CRT4060Amount = objLineItem.UnitPrice; 
                    if(objLineItem.PricebookEntry.productCode == 'ENC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4010')
                        objReportDetails.ENC4010Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4020')
                        objReportDetails.ENC4020Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCBN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.ENCBN4030Amount = objLineItem.UnitPrice;   
                    if(objLineItem.PricebookEntry.productCode == 'ENCCP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.ENCCP4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCCP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.ENCCP4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCE' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.ENCE4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCE' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.ENCE4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCL' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.ENCL4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCL' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.ENCL4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCS' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.ENCS4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCS' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.ENCS4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCSW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.ENCSW4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ENCSW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.ENCSW4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'ERD' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4110')
                        objReportDetails.ERD4110Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FBRHB' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FBRHB4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FBRNM' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                        objReportDetails.FBRNM4000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FCBR' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                        objReportDetails.FCBR4000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4020')
                        objReportDetails.FRM14020Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4010')
                        objReportDetails.FRM14010Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.FRM1E4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.FRM1E4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1H' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FRM1H4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1H' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FRM1H4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.FRM1L4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.FRM1L4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.FRM1L4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1N' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FRM1N4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.FRM1S4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM1S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.FRM1S4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.FRM2E4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.FRM2E4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2H' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FRM2H4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.FRM2L4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.FRM2L4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2N' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FRM2N4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                        objReportDetails.FRM2S4001Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRM2S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                        objReportDetails.FRM2S4002Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRMCN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FRMCN4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'FRMCP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                        objReportDetails.FRMCP4030Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4102')
                        objReportDetails.GRPW4102Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4092')
                        objReportDetails.GRPW4092Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4104')
                        objReportDetails.GRPW4104Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4091')
                        objReportDetails.GRPW4091Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'IFC12' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                        objReportDetails.IFC124000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'IND1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.IND14060Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'MEA' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                        objReportDetails.MEA4000Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'MEMC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                        objReportDetails.MEMC4040Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'MEMF' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                        objReportDetails.MEMF4040Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'MEMI' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                        objReportDetails.MEMI4040Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'MEMS' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                        objReportDetails.MEMS4040Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'MEMW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '2007')
                        objReportDetails.MEMW2007Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'MISC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                        objReportDetails.MISC4999Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'PRFEE' && objLineItem.PricebookEntry.product2.GL_CODE__C == '6110')
                        objReportDetails.PRFEE6110Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'SHIP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                        objReportDetails.SHIP4999Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'SLSTX' && objLineItem.PricebookEntry.product2.GL_CODE__C == '2819')
                        objReportDetails.SLSTX2819Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'TCEM' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4080')
                        objReportDetails.TCEM4080Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'WEBN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                        objReportDetails.WEBN4070Amount = objLineItem.UnitPrice;
                    if(objLineItem.PricebookEntry.productCode == 'WEBN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                        objReportDetails.WEBN4060Amount = objLineItem.UnitPrice;
                    
                }
                
          lstWrapper.add(objReportDetails);
            }
          system.debug('lstWrapper =='+lstWrapper);
    }
}