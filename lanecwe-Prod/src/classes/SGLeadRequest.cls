/**** This is the data format class used for receiving data from SG for SGLeadCreateREST class.
****/
global class SGLeadRequest{

    global class Products{
        public String  EnterpriseName;
        public Integer Quantity;
        public Integer Contractterm;
        public String  StartDate;
        public String  EndDate;
        public string  ProductName;
        public decimal UnitPrice;        
        public string  BillingFrequency;
        public string  Mincommitment;
        public string  UnitType;
        public decimal mincmmtamount;
    }
    public string LeadID;
    public String SlesgatewayID;
    public String Company;
    public string Source;
    public String CustomerFirstName;
    public String CustomerLastName;
    public String RepFirstName;
    public String RepLastName;
    public String Phone;    
    public String Email;
    public String Street;
    public String City;
    public String State;
    public String PostalCode;
    public String Country;
    public String ContractURL;
    public Integer BusinessType;
    public List<Products> ProductsOfInterest;
}