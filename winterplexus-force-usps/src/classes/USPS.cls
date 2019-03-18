/**
 *  USPS namespace class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
global with sharing class USPS {

    global with sharing class SubmittedAddress {
        public String FirmName { get; set; }
        public String Address1 { get; set; }
        public String Address2 { get; set; }
        public String City { get; set; }
        public String State { get; set; }
        public String Urbanization { get; set; }
        public String ZIP5 { get; set; }
        public String ZIP4 { get; set; }
    }

    global with sharing class ProcessedAddress {
        public String FirmName { get; set; }
        public String Address1 { get; set; }
        public String Address2 { get; set; }
        public String City { get; set; }
        public String State { get; set; }
        public String Urbanization { get; set; }
        public String ZIP5 { get; set; }
        public String ZIP4 { get; set; }
        public String ErrorCode { get; set; }
        public String ErrorSource { get; set; }
        public String ErrorDescription { get; set; }
    }

    global with sharing class AddressStandardization {

        private final String baseURL = 'http://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=';

//      private final String baseURL = 'https://secure.shippingapis.com/ShippingAPI.dll?API=Verify&XML=';

        private final String uid = '';

        private final integer timeout = 5000;

        public ProcessedAddress standardize(SubmittedAddress submitted) {
            DisplaySubmittedAddress(submitted);

            try {
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                request.setTimeout(timeout);
                request.setEndPoint(FormatEndPoint(submitted));

                Http http = new Http();
                HttpResponse response = http.send(request);

                USPS.ProcessedAddress processed = GetProcessedAddress(response.getBody());
                DisplayResponseBody(response.getBody());
                DisplayProcessedAddress(processed);
                return processed;
            }
            catch (System.Exception e) {
                System.debug(logginglevel.DEBUG, '# unable to standardize address: ' + e.getMessage());
                throw new USPSException('Unable to standardize address: ' + e.getMessage());
            }
        }

        private String FormatEndPoint(SubmittedAddress submitted) {
            String requestXML = '<AddressValidateRequest USERID="' + uid + '"><Address ID="0">';

            if (String.isEmpty(submitted.FirmName)) {
                submitted.FirmName = '';
            }
            if (String.isEmpty(submitted.Address1)) {
                submitted.Address1 = '';
            }
            if (String.isEmpty(submitted.Address2)) {
                submitted.Address2 = '';
            }
            if (String.isEmpty(submitted.City)) {
                submitted.City = '';
            }
            if (String.isEmpty(submitted.State)) {
                submitted.State = '';
            }
            if (String.isEmpty(submitted.Urbanization)) {
                submitted.Urbanization = '';
            }
            if (String.isEmpty(submitted.ZIP5)) {
                submitted.ZIP5 = '';
            }
            if (String.isEmpty(submitted.ZIP4)) {
                submitted.ZIP4 = '';
            }

            requestXML += '<FirmName>' + submitted.FirmName + '</FirmName>';
            requestXML += '<Address1>' + submitted.Address1 + '</Address1>';
            requestXML += '<Address2>' + submitted.Address2 + '</Address2>';
            requestXML += '<City>' + submitted.City + '</City>';
            requestXML += '<State>' + submitted.State + '</State>';
            requestXML += '<Urbanization>' + submitted.Urbanization + '</Urbanization>';
            requestXML += '<Zip5>' + submitted.ZIP5 + '</Zip5>';
            requestXML += '<Zip4>' + submitted.ZIP4 + '</Zip4>';
            requestXML += '</Address></AddressValidateRequest>';

            requestXML = EncodingUtil.urlEncode(requestXML, 'UTF-8');
            requestXML = baseURL + requestXML;
            return requestXML;
        }

        private USPS.ProcessedAddress GetProcessedAddress(String responseBody) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            XMLStreamReader reader = new XMLStreamReader(responseBody);

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'AddressValidateResponse') {
                        reader.next();
                        if (reader.getLocalName() == 'Address') {
                            return ParseResponse(reader);
                        }
                    }
                    if (reader.getLocalName() == 'Error') {
                        processed = ParseErrorReponse(reader);
                    }
                }
                reader.next();
            }
            return processed;
        }

        private USPS.ProcessedAddress ParseResponse(XMLStreamReader reader) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'Address') {
                        break;
                    }
                }
                else if (reader.getLocalName() == 'Error') {
                    return ParseErrorReponse(reader);
                }
                else if (reader.getLocalName() == 'FirmName') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.FirmName = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Address1') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.Address1 = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Address2') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.Address2 = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'City') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.City = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'State') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.State = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Urbanization') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.Urbanization = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Zip5') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.ZIP5 = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Zip4') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.ZIP4 = reader.getText();
                    }
                }
                reader.next();
            }
            return processed;
        }

        private USPS.ProcessedAddress ParseErrorReponse(XMLStreamReader reader) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'Error') {
                        break;
                    }
                }
                else if (reader.getLocalName() == 'Number') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error code: ' + reader.getText());
                        processed.ErrorCode = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Source') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error source: ' + reader.getText());
                        processed.ErrorSource = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Description') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error description: ' + reader.getText());
                        processed.ErrorDescription = reader.getText();
                    }
                }
                reader.next();
            }
            return processed;
        }

        private void DisplayResponseBody(String response_body) {
            string body = response_body.replaceAll('[\r\n]','.');
            System.debug(logginglevel.DEBUG, '# response body: ' + body);
        }

        private void DisplaySubmittedAddress(USPS.SubmittedAddress submitted) {
            System.debug(logginglevel.DEBUG, '# address standardization submitted address');
            System.debug(logginglevel.DEBUG, '# submitted.FirmName     : ' + submitted.FirmName);
            System.debug(logginglevel.DEBUG, '# submitted.Address1     : ' + submitted.Address1);
            System.debug(logginglevel.DEBUG, '# submitted.Address2     : ' + submitted.Address2);
            System.debug(logginglevel.DEBUG, '# submitted.City         : ' + submitted.City);
            System.debug(logginglevel.DEBUG, '# submitted.State        : ' + submitted.State);
            System.debug(logginglevel.DEBUG, '# submitted.Urbanization : ' + submitted.Urbanization);
            System.debug(logginglevel.DEBUG, '# submitted.ZIP5         : ' + submitted.ZIP5);
            System.debug(logginglevel.DEBUG, '# submitted.ZIP4         : ' + submitted.ZIP4);
        }

        private void DisplayProcessedAddress(USPS.ProcessedAddress processed) {
            System.debug(logginglevel.DEBUG, '# address standardization processed address');
            System.debug(logginglevel.DEBUG, '# processed.FirmName     : ' + processed.FirmName);
            System.debug(logginglevel.DEBUG, '# processed.Address1     : ' + processed.Address1);
            System.debug(logginglevel.DEBUG, '# processed.Address2     : ' + processed.Address2);
            System.debug(logginglevel.DEBUG, '# processed.City         : ' + processed.City);
            System.debug(logginglevel.DEBUG, '# processed.State        : ' + processed.State);
            System.debug(logginglevel.DEBUG, '# processed.Urbanization : ' + processed.Urbanization);
            System.debug(logginglevel.DEBUG, '# processed.ZIP5         : ' + processed.ZIP5);
            System.debug(logginglevel.DEBUG, '# processed.ZIP4         : ' + processed.ZIP4);
        }
    }

    global with sharing class ZIPCodeSearch {

        private final String baseURL = 'http://production.shippingapis.com/ShippingAPI.dll?API=ZipCodeLookup&XML=';

//      private final String baseURL = 'https://secure.shippingapis.com/ShippingAPI.dll?API=ZipCodeLookup&XML=';

        private final String uid = '448STATE5207';

        private final integer timeout = 5000;

        public ProcessedAddress search(SubmittedAddress submitted) {
            DisplaySubmittedAddress(submitted);

            try {
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                request.setTimeout(timeout);
                request.setEndPoint(FormatEndPoint(submitted));

                Http http = new Http();
                HttpResponse response = http.send(request);

                USPS.ProcessedAddress processed = GetProcessedAddress(response.getBody());
                DisplayResponseBody(response.getBody());
                DisplayProcessedAddress(processed);
                return processed;
            }
            catch (System.Exception e) {
                System.debug(logginglevel.DEBUG, '# unable to search ZIP code: ' + e.getMessage());
                throw new USPSException('Unable to search ZIP code: ' + e.getMessage());
            }
        }

        private String FormatEndPoint(SubmittedAddress submitted) {
            String requestXML = '<ZipCodeLookupRequest USERID="' + uid + '"><Address ID="0">';

            if (String.isEmpty(submitted.FirmName)) {
                submitted.FirmName = '';
            }
            if (String.isEmpty(submitted.Address1)) {
                submitted.Address1 = '';
            }
            if (String.isEmpty(submitted.Address2)) {
                submitted.Address2 = '';
            }
            if (String.isEmpty(submitted.City)) {
                submitted.City = '';
            }
            if (String.isEmpty(submitted.State)) {
                submitted.State = '';
            }

            requestXML += '<FirmName>' + submitted.FirmName + '</FirmName>';
            requestXML += '<Address1>' + submitted.Address1 + '</Address1>';
            requestXML += '<Address2>' + submitted.Address2 + '</Address2>';
            requestXML += '<City>' + submitted.City + '</City>';
            requestXML += '<State>' + submitted.State + '</State>';
            requestXML += '</Address></ZipCodeLookupRequest>';

            requestXML = EncodingUtil.urlEncode(requestXML, 'UTF-8');
            requestXML = baseURL + requestXML;
            return requestXML;
        }

        private USPS.ProcessedAddress GetProcessedAddress(String responseBody) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            XMLStreamReader reader = new XMLStreamReader(responseBody);

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'ZipCodeLookupResponse') {
                        reader.next();
                        if (reader.getLocalName() == 'Address') {
                            return ParseResponse(reader);
                        }
                    }
                    if (reader.getLocalName() == 'Error') {
                        processed = ParseErrorReponse(reader);
                    }
                }
                reader.next();
            }
            return processed;
        }

        private USPS.ProcessedAddress ParseResponse(XMLStreamReader reader) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'Address') {
                        break;
                    }
                }
                else if (reader.getLocalName() == 'Error') {
                    return ParseErrorReponse(reader);
                }
                else if (reader.getLocalName() == 'FirmName') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.FirmName = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Address1') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.Address1 = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Address2') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.Address2 = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'City') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.City = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'State') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.State = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Zip5') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.ZIP5 = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Zip4') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.ZIP4 = reader.getText();
                    }
                }
                reader.next();
            }
            return processed;
        }

        private USPS.ProcessedAddress ParseErrorReponse(XMLStreamReader reader) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'Error') {
                        break;
                    }
                }
                else if (reader.getLocalName() == 'Number') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error code: ' + reader.getText());
                        processed.ErrorCode = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Source') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error source: ' + reader.getText());
                        processed.ErrorSource = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Description') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error description: ' + reader.getText());
                        processed.ErrorDescription = reader.getText();
                    }
                }
                reader.next();
            }
            return processed;
        }

        private void DisplayResponseBody(String response_body) {
            string body = response_body.replaceAll('[\r\n]','.');
            System.debug(logginglevel.DEBUG, '# response body: ' + body);
        }

        private void DisplaySubmittedAddress(USPS.SubmittedAddress submitted) {
            System.debug(logginglevel.DEBUG, '# ZIP code search submitted address');
            System.debug(logginglevel.DEBUG, '# submitted.FirmName     : ' + submitted.FirmName);
            System.debug(logginglevel.DEBUG, '# submitted.Address1     : ' + submitted.Address1);
            System.debug(logginglevel.DEBUG, '# submitted.Address2     : ' + submitted.Address2);
            System.debug(logginglevel.DEBUG, '# submitted.City         : ' + submitted.City);
            System.debug(logginglevel.DEBUG, '# submitted.State        : ' + submitted.State);
        }

        private void DisplayProcessedAddress(USPS.ProcessedAddress processed) {
            System.debug(logginglevel.DEBUG, '# ZIP code search processed address');
            System.debug(logginglevel.DEBUG, '# processed.FirmName     : ' + processed.FirmName);
            System.debug(logginglevel.DEBUG, '# processed.Address1     : ' + processed.Address1);
            System.debug(logginglevel.DEBUG, '# processed.Address2     : ' + processed.Address2);
            System.debug(logginglevel.DEBUG, '# processed.City         : ' + processed.City);
            System.debug(logginglevel.DEBUG, '# processed.State        : ' + processed.State);
            System.debug(logginglevel.DEBUG, '# processed.ZIP5         : ' + processed.ZIP5);
            System.debug(logginglevel.DEBUG, '# processed.ZIP4         : ' + processed.ZIP4);
        }
    }

    global with sharing class CityStateSearch {

        private final String baseURL = 'http://production.shippingapis.com/ShippingAPI.dll?API=CityStateLookup&XML=';

//      private final String baseURL = 'https://secure.shippingapis.com/ShippingAPI.dll?API=CityStateLookup&XML=';

        private final String uid = '448STATE5207';

        private final integer timeout = 5000;

        public ProcessedAddress search(SubmittedAddress submitted) {
            DisplaySubmittedAddress(submitted);

            try {
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                request.setTimeout(timeout);
                request.setEndPoint(FormatEndPoint(submitted));

                Http http = new Http();
                HttpResponse response = http.send(request);

                USPS.ProcessedAddress processed = GetProcessedAddress(response.getBody());
                DisplayResponseBody(response.getBody());
                DisplayProcessedAddress(processed);
                return processed;
            }
            catch (System.Exception e) {
                System.debug(logginglevel.DEBUG, '# unable to search city/state: ' + e.getMessage());
                throw new USPSException('Unable to search city/state: ' + e.getMessage());
            }
        }

        private String FormatEndPoint(SubmittedAddress submitted) {
            String requestXML = '<CityStateLookupRequest USERID="' + uid + '"><ZipCode ID="0">';

            if (String.isEmpty(submitted.ZIP5)) {
                submitted.ZIP5 = '';
            }

            requestXML += '<Zip5>' + submitted.ZIP5 + '</Zip5>';
            requestXML += '</ZipCode></CityStateLookupRequest>';

            requestXML = EncodingUtil.urlEncode(requestXML, 'UTF-8');
            requestXML = baseURL + requestXML;
            return requestXML;
        }

        private USPS.ProcessedAddress GetProcessedAddress(String responseBody) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            XMLStreamReader reader = new XMLStreamReader(responseBody);

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'CityStateLookupResponse') {
                        reader.next();
                        if (reader.getLocalName() == 'ZipCode') {
                            return ParseResponse(reader);
                        }
                    }
                    if (reader.getLocalName() == 'Error') {
                        processed = ParseErrorReponse(reader);
                    }
                }
                reader.next();
            }
            return processed;
        }

        private USPS.ProcessedAddress ParseResponse(XMLStreamReader reader) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'ZipCode') {
                        break;
                    }
                }
                else if (reader.getLocalName() == 'Error') {
                    return ParseErrorReponse(reader);
                }
                else if (reader.getLocalName() == 'City') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.City = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'State') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.State = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Zip5') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        processed.ZIP5 = reader.getText();
                    }
                }
                reader.next();
            }
            return processed;
        }

        private USPS.ProcessedAddress ParseErrorReponse(XMLStreamReader reader) {
            USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'Error') {
                        break;
                    }
                }
                else if (reader.getLocalName() == 'Number') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error code: ' + reader.getText());
                        processed.ErrorCode = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Source') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error source: ' + reader.getText());
                        processed.ErrorSource = reader.getText();
                    }
                }
                else if (reader.getLocalName() == 'Description') {
                    reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        System.debug(logginglevel.DEBUG, '# error description: ' + reader.getText());
                        processed.ErrorDescription = reader.getText();
                    }
                }
                reader.next();
            }
            return processed;
        }

        private void DisplayResponseBody(String response_body) {
            string body = response_body.replaceAll('[\r\n]','.');
            System.debug(logginglevel.DEBUG, '# response body: ' + body);
        }

        private void DisplaySubmittedAddress(USPS.SubmittedAddress submitted) {
            System.debug(logginglevel.DEBUG, '# city/state search submitted address');
            System.debug(logginglevel.DEBUG, '# subitted.ZIP5          : ' + submitted.ZIP5);
        }

        private void DisplayProcessedAddress(USPS.ProcessedAddress processed) {
            System.debug(logginglevel.DEBUG, '# city/state search processed address');
            System.debug(logginglevel.DEBUG, '# processed.City         : ' + processed.City);
            System.debug(logginglevel.DEBUG, '# processed.State        : ' + processed.State);
            System.debug(logginglevel.DEBUG, '# processed.ZIP5         : ' + processed.ZIP5);
        }
    }

    public class USPSException extends Exception {
    }
}
