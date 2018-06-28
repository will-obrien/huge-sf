public class JRA_JSONReponse {
/*
PNC June 2015
Class to deserialize callout response into to can read using Apex 
*/

    public class Addresses {
        public String fax_area_code;
        public String created_at;
        public String updated_at;
        public String id;
        public String street_2;
        public String target_id;
        public String city;
        public String country;
        public String ext;
        public String kw_address_id;
        public String type;
        public String state;
        public String street;
        public String area_code;
        public String zip_code;
        public String fax;
        public String building;
        public String phone;
    }

    public List<Addresses> addresses;
    public String salutation;
    public String last_name;
    public String email;
    public String district_name;
    public String updated_at;
    public String fec_id;
    public String website;
    public String account_id;
    public String person_id;
    public String webform_url;
    public String webform_status;
    public String form_id;
    public String edited_on;
    public String gender;
    public String role;
    public String created_at;
    public String facebook;
    public String organization;
    public String title;
    public String rank;
    public String state_id;
    public String twitter;
    public String first_name;
    public String id;
    public String district_code;
    public String class_name;
    public String party;
    public String state;
    public String primary_delivery_method;

    
    public static JRA_JSONReponse parse(String json) {
        return (JRA_JSONReponse) System.JSON.deserialize(json, JRA_JSONReponse.class);
    }
  
public Static Map<String, List<JRA_JSONReponse> > getLegislatorMap(String sJSON) {
    //Because response uses integers as array keys, we need to do several loops through maps to get correct final response
    Map<String, List<JRA_JSONReponse>> LegislatorMap = new Map<String, List<JRA_JSONReponse> >();
    
    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(sJSON);
    //deserializeUntyped causes response to lose JSON formatting - so we re-encode back to JSON at each step
    String jsonSubset = JSON.serialize(m.get('data'));
    
    //re-encode as a Map
    Map<String,Object> jsonSubsetMap = (Map<String, Object>)JSON.deserializeUntyped(jsonSubset);

    //Now loop through array responses
    for (Object obj : jsonSubsetMap.values()){
        //re-encode as json, again!
        String jsonObj = JSON.serialize(obj);
        //Convert to JSON response class
        JRA_JSONReponse JRA = JRA_JSONReponse.parse(jsonObj);
        //Only include records with role and rank, since we only want legislators
        if (String.IsEmpty(JRA.role) == FALSE) {
            List<JRA_JSONReponse> templist;
            if (LegislatorMap.containskey(JRA.role) ) {
                templist = LegislatorMap.get(JRA.role);
            }
            else { 
                templist = new List<JRA_JSONReponse> ();
            }
            
            templist.add(JRA);
            LegislatorMap.put(JRA.role, templist);
        }
        
    }
//Return map of Legisaltors with Role as Key    
return LegislatorMap;
}

}