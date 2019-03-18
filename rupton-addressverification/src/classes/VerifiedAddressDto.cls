public with sharing class VerifiedAddressDto {

    public List<SesameVerificationResults>results;
    public String status;
    
    
    public class SesameVerificationResults{
        public String avc;                  //"AVC": "V44-I44-P7-100",
        public String address1;             //"Address1": "5 Day Dr",
        public String address2;             //"Address2": "Stafford VA 22556-1870",
        public String administrativeArea;        //"AdministrativeArea": "VA",
        public String countryName;    //"CountryName": "United States",
        public String deliveryAddress;    //"DeliveryAddress": "5 Day Dr",
        public String deliveryAddress1;    //"DeliveryAddress1": "5 Day Dr",
        public String iso3166_2;    //"ISO3166-2": "US",
        public String iso3166_3;    //"ISO3166-3": "USA",
        public String iso3166_n;    //"ISO3166-N": "840",
        public String locality;    //"Locality": "Stafford",
        public String postalCode;    //"PostalCode": "22556-1870",
        public String postalCodePrimary;    //"PostalCodePrimary": "22556",
        public String postalCodeSecondary;    //"PostalCodeSecondary": "1870",
        public String premise;    //"Premise": "5",
        public String premiseNumber;    //"PremiseNumber": "5",
        public String thoroughFare;    //"Thoroughfare": "Day Dr",
        public String thoroughFareName;    //"ThoroughfareName": "Day",
        public String thoroughFareTrailingType;    //"ThoroughfareTrailingType": "Dr",
        public String thoroughFareTypes;    //"ThoroughfareType": "Dr"
    }
}