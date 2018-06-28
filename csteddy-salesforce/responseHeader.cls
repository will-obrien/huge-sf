public class responseHeader {

public static Map<String, String> getall(HTTPResponse res) {

//get the list of header names (keys)
            string[] headerkeys = res.getHeaderKeys();
            system.debug(headerkeys);
            //create an object to store your header key-value pairs
            Map<string, string> headers = new map<string, string>();

            //iterate through they keys, and populate your map
            for(string s : headerkeys){
               if (s != null) {
               headers.put(s,res.getHeader(s));
               system.debug('header: ' + s + ' value: ' + res.getHeader(s));
               }
            }
            return headers;
            }
            
public static String get(HTTPResponse res, String headerkey) {

//get the list of header names (keys)
            string[] headerkeys = res.getHeaderKeys();
//            system.debug(headerkeys);

            //iterate through they keys, and return value of key when found
            for(string s : headerkeys){
               if (s == headerkey) {
               return res.getHeader(s);
               system.debug('header: ' + s + ' value: ' + res.getHeader(s));
               }
            }
            return null;
            }
}
