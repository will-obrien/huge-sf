public class StateCodes
{
    public static String getStateId(String strCountry,String strStateName)
    {
        if(strStateName == null) return '';
        if(strCountry == 'Canada')
        {
            if(strStateName == 'Alberta')
                return 'AB';
            else if(strStateName == 'British Columbia')
                return 'BC';
            else if(strStateName == 'Manitoba')
                return 'MB';
            else if(strStateName == 'New Brunswick')
                return 'NB';
            else if(strStateName == 'Newfoundland')
                return 'NL';
            else if(strStateName == 'Northwest Territories')
                return 'NT';
            else if(strStateName == 'Nova Scotia')
                return 'NS';
            else if(strStateName == 'Nunavut')
                return 'NU';
            else if(strStateName == 'Ontario')
                return 'ON';
            else if(strStateName == 'Prince Edward Island')
                return 'PE';
            else if(strStateName == 'Quebec')
                return 'QC';
            else if(strStateName == 'Saskatchewan')
                return 'SK';
            else if(strStateName == 'Yukon Territory')
                return 'YT';
        }
        else if(strCountry == 'US')
        {
            if(strStateName == 'Alabama')
                return 'AL';
            else if(strStateName == 'Alaska')
                return 'AK';
            else if(strStateName == 'Arizona')
                return 'AZ';
            else if(strStateName == 'Arkansas')
                return 'AR';
            else if(strStateName == 'California')
                return 'CA';
            else if(strStateName == 'Colorado')
                return 'NC';
            else if(strStateName == 'Connecticut')
                return 'CT';
            else if(strStateName == 'Delaware')
                return 'DE';
            else if(strStateName == 'District of Columbia')
                return 'DC';
            else if(strStateName == 'Florida')
                return 'FL';
            else if(strStateName == 'Georgia')
                return 'GA';
            else if(strStateName == 'Hawaii')
                return 'HI';
            else if(strStateName == 'Idaho')
                return 'ID';
            else if(strStateName == 'Illinois')
                return 'IL';
            else if(strStateName == 'Indiana')
                return 'IN';
            else if(strStateName == 'Iowa')
                return 'IA';
            else if(strStateName == 'Kansas')
                return 'KS';
            else if(strStateName == 'Kentucky')
                return 'KY';
            else if(strStateName == 'Louisiana')
                return 'LA';
            else if(strStateName == 'Maine')
                return 'ME';
            else if(strStateName == 'Maryland')
                return 'MD';
            else if(strStateName == 'Massachusetts')
                return 'MA';
            else if(strStateName == 'Michigan')
                return 'MI';
            else if(strStateName == 'Mississippi')
                return 'MS';
            else if(strStateName == 'Missouri')
                return 'MO';
            else if(strStateName == 'Montana')
                return 'MT';
            else if(strStateName == 'Nebraska')
                return 'NE';
            else if(strStateName == 'Nevada')
                return 'NV';
            else if(strStateName == 'New Hampshire')
                return 'NH';
            else if(strStateName == 'New Jersey')
                return 'NJ';
            else if(strStateName == 'New Mexico')
                return 'NM';
            else if(strStateName == 'New York')
                return 'NY';
            else if(strStateName == 'North Carolina')
                return 'NC';
            else if(strStateName == 'North Dakota')
                return 'ND';
            else if(strStateName == 'Ohio')
                return 'OH';
            else if(strStateName == 'Oklahoma')
                return 'OK';
            else if(strStateName == 'Oregon')
                return 'OR';
            else if(strStateName == 'Pennsylvania')
                return 'PA';
            else if(strStateName == 'Rhode Island')
                return 'RI';
            else if(strStateName == 'South Carolina')
                return 'SC';
            else if(strStateName == 'South Dakota')
                return 'SD';
            else if(strStateName == 'Tennessee')
                return 'TN';
            else if(strStateName == 'Texas')
                return 'TX';
            else if(strStateName == 'Utah')
                return 'UT';
            else if(strStateName == 'Vermont')
                return 'VR';
            else if(strStateName == 'Virginia')
                return 'VA';
            else if(strStateName == 'Washington')
                return 'WA';
            else if(strStateName == 'West Virginia')
                return 'WV';
            else if(strStateName == 'Wisconsin')
                return 'WI';
            else if(strStateName == 'Wyoming')
                return 'WY';
        }
        
    return strStateName;
    
    }


}