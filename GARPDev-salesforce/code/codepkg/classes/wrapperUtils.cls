global class wrapperUtils
{
     public class wrapperProductInfo
    {
        public string strProductCode {get;set;}
        public string strDisplayName {get;set;}
        public string strGlCode {get;set;}
        public decimal examPrice{get;set;}
        public boolean bERPEnrollment{get;set;}
        public boolean bSwitchFess{get;set;}
        public boolean bFRMEnrollment{get;set;}
        public string strSwitchGlCode{get;set;}
        public string switchprodcode {get;set;}
        public decimal switchprice {get;set;}
    
    }
    
    public class wrapperProductDetails
    {
        public string strProductCode {get;set;}
      
        public decimal dPrice{get;set;}
        public string strGLCode{get;set;}
    }
    
    public class addressWrapper
    {
        public string strCity{get;set;}
        public string strStateCode{get;set;}
        public string strZipCode{get;set;}
        public string strAddress{get;set;}
    
    }
    
    public class upsWrapper
    {
        public string strUPSDesc {get;set;}
      
        public decimal dPrice{get;set;}
        
        public List<addressWrapper> lstMatchingAddress{get;set;}
    }

}