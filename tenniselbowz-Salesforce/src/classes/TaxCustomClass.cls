/**
 *  
 *  TaxCustomClass
 *   
 *  @2013-2014 Apttus Inc. All rights reserved.
 */

public with sharing class TaxCustomClass {
    
    // Input Fields
    public String batchCode                     {get; set;}
    public String locationCode                  {get; set;}
    public String customerCode                  {get; set;}
    public String taxExemptionNumber            {get; set;}
    public String docCode                       {get; set;}
    public String lineNumber                    {get; set;}
    public String itemCode                      {get; set;}
    public String itemDescription               {get; set;}
    public String originalDocCode               {get; set;}
    public Date   originalTransDate             {get; set;}
    // Output Fields
    public String resultCode                    {get; set;}
    
    
    /*
     * Class Constructor
     *
     */
    public TaxCustomClass() {
    }
    
    
    /*
     * Class Constructor
     *
     */
    public TaxCustomClass(String batchCode, 
        String locationCode, 
        String customerCode,
        String taxExemptionNumber, 
        String docCode, 
        String lineNumber, 
        String itemCode,
        String itemDescription,
        String resultCode,
        String originalDocCode,
        Date   originalTransDate) {
            
            this.batchCode          = batchCode;
            this.locationCode       = locationCode;
            this.customerCode       = customerCode;
            this.taxExemptionNumber = taxExemptionNumber;
            this.docCode            = docCode;
            this.lineNumber         = lineNumber;
            this.itemCode           = itemCode;  
            this.itemDescription    = itemDescription;
            this.resultCode         = resultCode;
            this.originalDocCode    = originalDocCode;
            this.originalTransDate  = originalTransDate;
            
    }
    
    
    /*
     * Class Constructor
     *
     */   
    public TaxCustomClass(TaxCustomClass taxCustomClass) {
            
            this.batchCode          = taxCustomClass.batchCode;
            this.locationCode       = taxCustomClass.locationCode;
            this.customerCode       = taxCustomClass.customerCode;
            this.taxExemptionNumber = taxCustomClass.taxExemptionNumber;
            this.docCode            = taxCustomClass.docCode;
            this.lineNumber         = taxCustomClass.lineNumber;
            this.itemCode           = taxCustomClass.itemCode;  
            this.itemDescription    = taxCustomClass.itemDescription;
            this.resultCode         = taxCustomClass.resultCode;
            this.originalDocCode    = originalDocCode;
            this.originalTransDate  = originalTransDate;      
    }  
}