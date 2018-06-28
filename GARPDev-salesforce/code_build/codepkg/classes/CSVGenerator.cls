public class CSVGenerator
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
    String strCompanyName = '';
    public CSVGenerator()
    {
        dtStartDate = Date.valueOf(ApexPages.currentPage().getParameters().get('stDate'));
        dtEndDate = Date.valueOf(ApexPages.currentPage().getParameters().get('endDate'));
         bIsTax = Boolean.valueOf(ApexPages.currentPage().getParameters().get('Taxable') == null ? 'false' : ApexPages.currentPage().getParameters().get('Taxable'));
        bIsRegular = Boolean.valueOf(ApexPages.currentPage().getParameters().get('Regular') == null ? 'false' : ApexPages.currentPage().getParameters().get('Regular'));
        strCompanyName = ApexPages.currentPage().getParameters().get('Company') == null ? '' : ApexPages.currentPage().getParameters().get('Company');
        prepareRefundHeader();
        prepareHeader();
        prepareWrapper();
        strTest = 'TESTVAL,TESTVAL1';
        
        
    }
    
    public void prepareRefundHeader()
    {

        //strRefundHeader = 'CRNInvoiceNum,GARP ID,IsAutoRenew,Currency,Country,Shipping To,Payment Type,Date Paid,Date Purchased,OnlinePayNumber,FRM1,FRM1E,FRM1H,FRM1L,FRM2E,FRM2H,FRM2L,MEMF,MEMI,SHIP,SLSTX';
        
        strRefundHeader = 'CRNInvoiceNum,GARP ID,Company Name,IsAutoRenew,Currency,Country,Shipping To,Payment Type,Date Paid,Date Purchased,OnlinePayNumber';
        
        loadRefundData();
    }
    
    public void loadRefundData()
    {
        
        List<Product_Refunds__c> lstProdRefunds = [select Product_Code__c,Product__r.Gl_Code__c,Product__r.ProductCode,Payment_Transaction__c,Product__c,Reason__c,Refund_amount__c,Refund_Code__c,Opportunity__c,Opportunity__r.Display_Invoice_Number__c,Opportunity__r.GARP_Member_ID__c,Opportunity__r.Auto_Renew__c,Opportunity__r.Company__c,Opportunity__r.ChargentSFA__Billing_Country__c,Opportunity__r.ChargentSFA__Payment_Method__c,Opportunity__r.closedate,Opportunity__r.createddate,Opportunity__r.ChargentSFA__Customer_Token__c,Opportunity__r.Amount,Opportunity__r.Shipping_Country__c,Opportunity__r.ChargentSFA__Tokenization__c,Opportunity__r.Shipping_City__c,Opportunity__r.Has_Books__c from Product_Refunds__c where Payment_Transaction__r.ChargentSFA__Opportunity__r.CloseDate >=: dtStartDate and Payment_Transaction__r.ChargentSFA__Opportunity__r.CloseDate <=: dtEndDate and Status__c =: 'Approved'and Opportunity__r.Company__c =: strCompanyName];
        if(test.isRunningTest()){
            lstProdRefunds = [select Product_Code__c,Product__r.Gl_Code__c,Product__r.ProductCode,Payment_Transaction__c,Product__c,Reason__c,Refund_amount__c,Refund_Code__c,Opportunity__c,Opportunity__r.Display_Invoice_Number__c,Opportunity__r.GARP_Member_ID__c,Opportunity__r.Auto_Renew__c,Opportunity__r.Company__c,Opportunity__r.ChargentSFA__Billing_Country__c,Opportunity__r.ChargentSFA__Payment_Method__c,Opportunity__r.closedate,Opportunity__r.createddate,Opportunity__r.ChargentSFA__Customer_Token__c,Opportunity__r.Amount,Opportunity__r.Shipping_Country__c,Opportunity__r.ChargentSFA__Tokenization__c,Opportunity__r.Shipping_City__c,Opportunity__r.Has_Books__c from Product_Refunds__c];    

        }
        
        
        //strRefundColumns = '';
        lstRefundWrapper = new List<reportWrapper>();
        decimal dAmount = 0;
        for(Product_Refunds__c objRefund : lstProdRefunds) 
        {
            //If regular box is checked and payment type is credit card then we should display only credit card opportunities, else all opps should display.
            if(bIsRegular && objRefund.Opportunity__r.ChargentSFA__Payment_Method__c != 'Credit Card') continue;
            boolean bHasFRM1Ship = false;
            boolean bHasFRM2Ship = false;
            boolean bHasERPShip = false;
            boolean bHasFBRSHip = false;
            boolean bHasICBRRSHip = false;
             reportWrapper objReportDetails = new reportWrapper();
             objReportDetails.Refund_Object = objRefund;
            // objReportDetails.opp = objRefund.Opportunity__c;
            
            if(objRefund.Opportunity__r.Has_Books__c)
            {
                objReportDetails.strShippingInfo = objRefund.Opportunity__r.Shipping_City__c + '-' +objRefund.Opportunity__r.Shipping_Country__c;
            }
            if(objRefund.Product__r.ProductCode == 'AFREE4' && objRefund.Product__r.Gl_Code__c == '4999')
            {
                objReportDetails.AFREE4999Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CBR' && objRefund.Product__r.Gl_Code__c == '4000')
            {
                objReportDetails.CBR4000Amount = objRefund.Refund_amount__c;
                bHasICBRRSHip = true;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CBR2A' && objRefund.Product__r.Gl_Code__c == '4000')
            {
                objReportDetails.CBR2A4000Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CBREL' && objRefund.Product__r.Gl_Code__c == '4999')
            {
                objReportDetails.CBREL4000Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CBRHB' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.CBRHB4030Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CBRHI' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.CBRHI4030Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CBRNM' && objRefund.Product__r.Gl_Code__c == '4000')
            {
                objReportDetails.CBRNM4000Amount = objRefund.Refund_amount__c;
                bHasICBRRSHip = true;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CHMT1' && objRefund.Product__r.Gl_Code__c == '4070')
            {
                objReportDetails.CHMT14070Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CMCNY' && objRefund.Product__r.Gl_Code__c == '4070')
            {
                objReportDetails.CMCNY4070Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CMCNY' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.CMCNY4060Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CNY13' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.CNY134060Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CNY13' && objRefund.Product__r.Gl_Code__c == '4070')
            {
                objReportDetails.CNY134070Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CRF' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.CRF4060Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CRF' && objRefund.Product__r.Gl_Code__c == '4070')
            {
                objReportDetails.CRF4070Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CRFA' && objRefund.Product__r.Gl_Code__c == '4070')
            {
                objReportDetails.CRFA4070Amount = objRefund.Refund_amount__c;    
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CRFA' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.CRFA4060Amount = objRefund.Refund_amount__c; 
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }   
            if(objRefund.Product__r.ProductCode == 'CRT' && objRefund.Product__r.Gl_Code__c == '4070')
            {
                objReportDetails.CRT4070Amount = objRefund.Refund_amount__c; 
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CRT' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.CRT4060Amount = objRefund.Refund_amount__c; 
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'CRT' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.CRT4060Amount = objRefund.Refund_amount__c; 
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENC' && objRefund.Product__r.Gl_Code__c == '4010')
            {
                objReportDetails.ENC4010Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.productCode == 'ERPH')
            {
                bHasERPShip = true;
            }
            if(objRefund.Product__r.ProductCode == 'ENC' && objRefund.Product__r.Gl_Code__c == '4020')
            {
                objReportDetails.ENC4020Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCBN' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.ENCBN4030Amount = objRefund.Refund_amount__c; 
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }  
            if(objRefund.Product__r.ProductCode == 'ENCCP' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.ENCCP4030Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCCP' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.ENCCP4030Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCE' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.ENCE4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCE' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.ENCE4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCL' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.ENCL4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCL' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.ENCL4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCS' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.ENCS4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCS' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.ENCS4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCSW' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.ENCSW4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ENCSW' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.ENCSW4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'ERD' && objRefund.Product__r.Gl_Code__c == '4110')
            {
                objReportDetails.ERD4110Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FBRHB' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.FBRHB4030Amount = objRefund.Refund_amount__c;
                
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FBRNM' && objRefund.Product__r.Gl_Code__c == '4000')
            {
                objReportDetails.FBRNM4000Amount = objRefund.Refund_amount__c;
                bHasFBRSHip = true;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FCBR' && objRefund.Product__r.Gl_Code__c == '4000')
            {
                objReportDetails.FCBR4000Amount = objRefund.Refund_amount__c;
                bHasFBRSHip = true;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1' && objRefund.Product__r.Gl_Code__c == '4020')
            {
                objReportDetails.FRM14020Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1' && objRefund.Product__r.Gl_Code__c == '4010')
            {
                objReportDetails.FRM14010Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1E' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.FRM1E4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1E' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.FRM1E4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1H' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.FRM1H4030Amount = objRefund.Refund_amount__c;
                bHasFRM1Ship = true;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1L' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.FRM1L4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1L' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.FRM1L4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1L' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.FRM1L4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1N' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.FRM1N4030Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1S' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.FRM1S4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM1S' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.FRM1S4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2E' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.FRM2E4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2E' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.FRM2E4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2H' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.FRM2H4030Amount = objRefund.Refund_amount__c;
                bHasFRM2Ship = true;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2L' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.FRM2L4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2L' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.FRM2L4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2N' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.FRM2N4030Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2S' && objRefund.Product__r.Gl_Code__c == '4001')
            {
                objReportDetails.FRM2S4001Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRM2S' && objRefund.Product__r.Gl_Code__c == '4002')
            {
                objReportDetails.FRM2S4002Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRMCN' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.FRMCN4030Amount = objRefund.Refund_amount__c;
            
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'FRMCP' && objRefund.Product__r.Gl_Code__c == '4030')
            {
                objReportDetails.FRMCP4030Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'GRPW' && objRefund.Product__r.Gl_Code__c == '4102')
            {
                objReportDetails.GRPW4102Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'GRPW' && objRefund.Product__r.Gl_Code__c == '4092')
            {
                objReportDetails.GRPW4092Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'GRPW' && objRefund.Product__r.Gl_Code__c == '4104')
            {
                objReportDetails.GRPW4104Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'GRPW' && objRefund.Product__r.Gl_Code__c == '4091')
            {
                objReportDetails.GRPW4091Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'IFC12' && objRefund.Product__r.Gl_Code__c == '4000')
            {
                objReportDetails.IFC124000Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'IND1' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.IND14060Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'MEA' && objRefund.Product__r.Gl_Code__c == '4000')
            {
                objReportDetails.MEA4000Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'MEMC' && objRefund.Product__r.Gl_Code__c == '4040')
            {
                objReportDetails.MEMC4040Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'MEMF' && objRefund.Product__r.Gl_Code__c == '4040')
            {
                objReportDetails.MEMF4040Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'MEMI' && objRefund.Product__r.Gl_Code__c == '4040')
            {
                objReportDetails.MEMI4040Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'MEMS' && objRefund.Product__r.Gl_Code__c == '4040')
            {
                objReportDetails.MEMS4040Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'MEMW' && objRefund.Product__r.Gl_Code__c == '2007')
            {
                objReportDetails.MEMW2007Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'MISC' && objRefund.Product__r.Gl_Code__c == '4999')
            {
                objReportDetails.MISC4999Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'PRFEE' && objRefund.Product__r.Gl_Code__c == '6110')
            {
                objReportDetails.PRFEE6110Amount = objRefund.Refund_amount__c;
                
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.productCode == 'SHIP' && objRefund.Product__r.GL_CODE__C == '4999')
            {
                objReportDetails.SHIP4999Amount = objRefund.Refund_amount__c;
                if(bHasFRM2Ship && bHasFRM1Ship)
                    objReportDetails.FRM1ShipAmt = objRefund.Refund_amount__c;
                 else if(bHasFRM1Ship)
                    objReportDetails.FRM1ShipAmt = objRefund.Refund_amount__c;
                else if(bHasFRM2Ship)
                    objReportDetails.FRM2ShipAmt = objRefund.Refund_amount__c;
                else if(bHasERPShip)
                    objReportDetails.ERPShipAmt = objRefund.Refund_amount__c;
                else if(bHasFBRShip)
                    objReportDetails.FBRShipAmt = objRefund.Refund_amount__c;
                else if(bHasICBRRSHip)
                     objReportDetails.ICBRRShipAmt = objRefund.Refund_amount__c;   

                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'SLSTX' && objRefund.Product__r.Gl_Code__c == '2819')
            {
                objReportDetails.SLSTX2819Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'TCEM' && objRefund.Product__r.Gl_Code__c == '4080')
            {
                objReportDetails.TCEM4080Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'WEBN' && objRefund.Product__r.Gl_Code__c == '4070')
            {
                objReportDetails.WEBN4070Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            if(objRefund.Product__r.ProductCode == 'WEBN' && objRefund.Product__r.Gl_Code__c == '4060')
            {
                objReportDetails.WEBN4060Amount = objRefund.Refund_amount__c;
                dAmount += objRefund.Refund_amount__c == null ? 0 : objRefund.Refund_amount__c;
            }
            
            
            /*if(objRefund.Product_Code__c == 'FRM1')
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
                objReportDetails.SLSTXRefundAmt = objRefund.Refund_amount__c;*/
                
            objReportDetails.dTotal =  dAmount;
            lstRefundWrapper.add(objReportDetails);
        }
        
    }
    
    public void prepareHeader()
    {
        strHeader = '';
        strHeader = 'Purchase No,GARPID,Company Name,IsAutoRenew,Currency,Country,Shipping To,Payment Type,Date Paid,Date of Purchase,Online Paynumber';
        String strProdCodes = '';
        String strQuery = 'select unitprice,productcode,product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and isActive = true ';
        if(bIsTax)
          
        for(PriceBookEntry objPriceBook : Database.Query(strQuery)) 
        {
            if(strProdCodes != '') strProdCodes += ',';
            strProdCodes += objPriceBook.productcode + ' (' + objPriceBook.product2.Gl_Code__c + ')';
            setProductCodes.add(objPriceBook.productcode);
        }
       String strBooksHeader = 'Shipping and Handling For 2015 FRM Part I Books,Shipping and Handling For 2015 FRM Part II Books,Shipping and Handling For 2015 ERP Course Pack,Shipping and Handling For FBR TextBook,Shipping and Handling For Intergrated Bank Risk Management';
       if(bIsTax)
        strBooksHeader = strBooksHeader + ',' + 'Taxable Amount';
        
       strHeader += ',' + strProdCodes + strBooksHeader + ',Total Amount';
       strRefundHeader += ',' + strProdCodes + strBooksHeader + ',Total Amount';
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
        list<opportunity> oppList = [SELECT Amount,Auto_Renew__c,Company__c,ChargentSFA__Billing_Country__c,ChargentSFA__Payment_Method__c,GARP_Member_ID__c,ChargentSFA__Tokenization__c, Id, ChargentSFA__Customer_Token__c, Display_Invoice_Number__c,CreatedDate,Shipping_City__c,Shipping_Country__c,Has_Books__c,CloseDate,GARP_Invoice_Number__c,Name, (SELECT Quantity, ListPrice,UnitPrice,PriceBookEntry.UnitPrice, PricebookEntry.Name,
                                  PricebookEntry.product2.Family,PricebookEntry.productCode,PricebookEntry.product2.GL_CODE__C FROM OpportunityLineItems where PricebookEntry.productCode in: setProductCodes) FROM Opportunity where CloseDate >=: dtStartDate and CloseDate <=: dtEndDate and Company__c =: strCompanyName];
        if(test.isRunningTest()){
            oppList = [SELECT Auto_Renew__c,Company__c,ChargentSFA__Billing_Country__c,ChargentSFA__Payment_Method__c,GARP_Member_ID__c,ChargentSFA__Tokenization__c,Amount, Id, ChargentSFA__Customer_Token__c, Display_Invoice_Number__c,CreatedDate,Shipping_City__c,Shipping_Country__c,Has_Books__c,CloseDate,GARP_Invoice_Number__c,Name, (SELECT Quantity, ListPrice,UnitPrice,PriceBookEntry.UnitPrice, PricebookEntry.Name,
                                  PricebookEntry.product2.Family,PricebookEntry.productCode,PricebookEntry.product2.GL_CODE__C FROM OpportunityLineItems where PricebookEntry.productCode in: setProductCodes) FROM Opportunity ];
     
            
        }
        for(Opportunity objOpp : oppList)
        {
                //If regular box is checked and payment type is credit card then we should display only credit card opportunities, else all opps should display.
                if(bIsRegular && objOpp.ChargentSFA__Payment_Method__c != 'Credit Card') continue;
                reportWrapper objReportDetails = new reportWrapper();
                objReportDetails.opp = objOpp;
                objReportDetails.payment = mapPayments.get(objOpp.Id);
                //objReportDetails.strShipTo = objOpp.Shipping_Country__c + ' - ' + objOpp.Shipping_Country__c;
                if(objOpp.Has_Books__c)
                {
                    objReportDetails.strShippingInfo = objOpp.Shipping_City__c + '-' +objOpp.Shipping_Country__c;
                }
                //String strVariableName= '';
                Decimal dAmount = 0;
                boolean bHasFRM1Ship = false;
                boolean bHasFRM2Ship = false;
                boolean bHasERPShip = false;
                boolean bHasFBRSHip = false;
                boolean bHasICBRRSHip = false;
                Decimal dTaxableAmount = 0;
        
                for(OpportunityLineItem objLineItem : objOpp.OpportunityLineItems)
                {
                    if(objLineItem.PricebookEntry.productCode == 'AFREE4' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                    {
                        objReportDetails.AFREE4999Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CBR' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                    {
                        objReportDetails.CBR4000Amount = objLineItem.UnitPrice;
                        bHasICBRRSHip = true;
                        if(bIsTax)
                        {
                         objReportDetails.ICBRRShipAmt = objLineItem.UnitPrice;
                         dTaxableAmount += objLineItem.UnitPrice;
                        }
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CBR2A' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                    {
                        objReportDetails.CBR2A4000Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CBREL' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                    {
                        objReportDetails.CBREL4000Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CBRHB' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.CBRHB4030Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CBRHI' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.CBRHI4030Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CBRNM' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                    {
                        objReportDetails.CBRNM4000Amount = objLineItem.UnitPrice;
                        bHasICBRRSHip = true;
                        if(bIsTax)
                        {
                            objReportDetails.ICBRRShipAmt = objLineItem.UnitPrice;
                            dTaxableAmount += objLineItem.UnitPrice;
                        }
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CHMT1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                    {
                        objReportDetails.CHMT14070Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CMCNY' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                    {
                        objReportDetails.CMCNY4070Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CMCNY' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.CMCNY4060Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CNY13' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.CNY134060Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CNY13' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                    {
                        objReportDetails.CNY134070Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CRF' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.CRF4060Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CRF' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                    {
                        objReportDetails.CRF4070Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CRFA' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                    {
                        objReportDetails.CRFA4070Amount = objLineItem.UnitPrice;    
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CRFA' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.CRFA4060Amount = objLineItem.UnitPrice; 
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }   
                    if(objLineItem.PricebookEntry.productCode == 'CRT' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                    {
                        objReportDetails.CRT4070Amount = objLineItem.UnitPrice; 
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CRT' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.CRT4060Amount = objLineItem.UnitPrice; 
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'CRT' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.CRT4060Amount = objLineItem.UnitPrice; 
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4010')
                    {
                        objReportDetails.ENC4010Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4020')
                    {
                        objReportDetails.ENC4020Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCBN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.ENCBN4030Amount = objLineItem.UnitPrice; 
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }  
                    if(objLineItem.PricebookEntry.productCode == 'ENCCP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.ENCCP4030Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCCP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.ENCCP4030Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCE' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.ENCE4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCE' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.ENCE4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCL' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.ENCL4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCL' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.ENCL4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCS' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.ENCS4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCS' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.ENCS4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCSW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.ENCSW4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ENCSW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.ENCSW4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ERD' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4110')
                    {
                        objReportDetails.ERD4110Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FBRHB' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.FBRHB4030Amount = objLineItem.UnitPrice;
                        
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FBRNM' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                    {
                        objReportDetails.FBRNM4000Amount = objLineItem.UnitPrice;
                        bHasFBRSHip = true;
                        if(bIsTax)
                        {
                            objReportDetails.FBRShipAmt = objLineItem.UnitPrice;
                            dTaxableAmount += objLineItem.UnitPrice;
                        }
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FCBR' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                    {
                        objReportDetails.FCBR4000Amount = objLineItem.UnitPrice;
                        bHasFBRSHip = true;
                        if(bIsTax)
                        {
                            objReportDetails.FBRShipAmt = objLineItem.UnitPrice;
                            dTaxableAmount += objLineItem.UnitPrice;
                        }
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4020')
                    {
                        objReportDetails.FRM14020Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4010')
                    {
                        objReportDetails.FRM14010Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.FRM1E4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.FRM1E4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1H' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.FRM1H4030Amount = objLineItem.UnitPrice;
                        bHasFRM1Ship = true;
                        if(bIsTax)
                        {
                            objReportDetails.FRM1ShipAmt = objLineItem.UnitPrice;
                            dTaxableAmount += objLineItem.UnitPrice;
                        }
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    
                    if(objLineItem.PricebookEntry.productCode == 'FRM1L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.FRM1L4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.FRM1L4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.FRM1L4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1N' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.FRM1N4030Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.FRM1S4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM1S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.FRM1S4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.FRM2E4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2E' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.FRM2E4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2H' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.FRM2H4030Amount = objLineItem.UnitPrice;
                        bHasFRM2Ship = true;
                        if(bIsTax)
                        {
                            objReportDetails.FRM2ShipAmt = objLineItem.UnitPrice;
                            dTaxableAmount += objLineItem.UnitPrice;
                        }
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.FRM2L4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2L' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.FRM2L4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2N' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.FRM2N4030Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4001')
                    {
                        objReportDetails.FRM2S4001Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRM2S' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4002')
                    {
                        objReportDetails.FRM2S4002Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRMCN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.FRMCN4030Amount = objLineItem.UnitPrice;
                    
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'FRMCP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4030')
                    {
                        objReportDetails.FRMCP4030Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4102')
                    {
                        objReportDetails.GRPW4102Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4092')
                    {
                        objReportDetails.GRPW4092Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4104')
                    {
                        objReportDetails.GRPW4104Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'GRPW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4091')
                    {
                        objReportDetails.GRPW4091Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'IFC12' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                    {
                        objReportDetails.IFC124000Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'IND1' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.IND14060Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'MEA' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4000')
                    {
                        objReportDetails.MEA4000Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'MEMC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                    {
                        objReportDetails.MEMC4040Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'MEMF' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                    {
                        objReportDetails.MEMF4040Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'MEMI' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                    {
                        objReportDetails.MEMI4040Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'MEMS' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4040')
                    {
                        objReportDetails.MEMS4040Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'MEMW' && objLineItem.PricebookEntry.product2.GL_CODE__C == '2007')
                    {
                        objReportDetails.MEMW2007Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'MISC' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                    {
                        objReportDetails.MISC4999Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'PRFEE' && objLineItem.PricebookEntry.product2.GL_CODE__C == '6110')
                    {
                        objReportDetails.PRFEE6110Amount = objLineItem.UnitPrice;
                        
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'ERPH')
                    {
                        bHasERPShip = true;
                        if(bIsTax)
                        {
                            objReportDetails.ERPShipAmt = objLineItem.UnitPrice;
                            dTaxableAmount += objLineItem.UnitPrice;
                        }
                        
                    }
                    if(objLineItem.PricebookEntry.productCode == 'SHIP' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4999')
                    {
                        objReportDetails.SHIP4999Amount = objLineItem.UnitPrice;
                        if(!bIsTax)
                        {
                            if(bHasFRM2Ship && bHasFRM1Ship)
                                objReportDetails.FRM1ShipAmt = objLineItem.UnitPrice;
                            else if(bHasFRM1Ship)
                                objReportDetails.FRM1ShipAmt = objLineItem.UnitPrice;
                            else if(bHasFRM2Ship)
                                objReportDetails.FRM2ShipAmt = objLineItem.UnitPrice;
                            else if(bHasERPShip)
                                objReportDetails.ERPShipAmt = objLineItem.UnitPrice;
                            else if(bHasFBRShip)
                                objReportDetails.FBRShipAmt = objLineItem.UnitPrice;
                            else if(bHasICBRRSHip)
                                 objReportDetails.ICBRRShipAmt = objLineItem.UnitPrice;   
                        }
                        dTaxableAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                        
                    }
                    if(objLineItem.PricebookEntry.productCode == 'SLSTX' && objLineItem.PricebookEntry.product2.GL_CODE__C == '2819')
                    {
                        objReportDetails.SLSTX2819Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'TCEM' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4080')
                    {
                        objReportDetails.TCEM4080Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'WEBN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4070')
                    {
                        objReportDetails.WEBN4070Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    if(objLineItem.PricebookEntry.productCode == 'WEBN' && objLineItem.PricebookEntry.product2.GL_CODE__C == '4060')
                    {
                        objReportDetails.WEBN4060Amount = objLineItem.UnitPrice;
                        dAmount += objLineItem.UnitPrice == null ? 0 : objLineItem.UnitPrice;
                    }
                    objReportDetails.TaxableAmount = dTaxableAmount; 
                    

                    
                }
           objReportDetails.dTotal =  dAmount;
          lstWrapper.add(objReportDetails);
            }
          system.debug('lstWrapper =='+lstWrapper);
    }
}