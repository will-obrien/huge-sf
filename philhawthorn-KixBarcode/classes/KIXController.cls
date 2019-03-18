public class KIXController 
{
    private final String solid = 'solid';
    private final String space = 'space';
    
    public String postCodeString {get;set;}
    
    public String[] getPostCodeItems() 
    {
        String[] items = new String[]{};
       	for(Integer i = 0; i < postCodeString.length() ; i++)
        {
            items.add(postCodeString.substring(i, i+1));
        }
        return items;
    }
    
    public List<String> getMids()
    {
        return new List<String>{solid,solid,solid,solid};
    }

    private Map<String,String[]> barMap;
    private Map<String,String[]> getBarMap()
    {
        if(barMap == null)
        {
            barMap = new Map<String,String[]>{'0011'=>new String[]{},'0101'=>new String[]{},'0110'=>new String[]{},'1001'=>new String[]{},'1010'=>new String[]{},'1100'=>new String[]{}};

            for(String m : barMap.keySet())
            {
                for(Integer i=0; i<4; i++)
                {
                    String bit = m.substring(i,i+1);
                    barMap.get(m).add(bit=='0'?space:solid);
                }
            }
        }
        return barMap;
    }

    private Map<String,String[]> topBitsMap;
    public Map<String,String[]> getTopMap()
    {
        if(topBitsMap==null)
        {
	    barMap = getBarMap();
            topBitsMap = new Map<String,String[]>{
                '0'=>barMap.get('0011'),
                '1'=>barMap.get('0011'),
                '2'=>barMap.get('0011'),
                '3'=>barMap.get('0011'),
                '4'=>barMap.get('0011'),
                '5'=>barMap.get('0011'),
                '6'=>barMap.get('0101'),
                '7'=>barMap.get('0101'),
                '8'=>barMap.get('0101'),
                '9'=>barMap.get('0101'),
                'A'=>barMap.get('0101'),
                'B'=>barMap.get('0101'),
                'C'=>barMap.get('0110'),
                'D'=>barMap.get('0110'),
                'E'=>barMap.get('0110'),
                'F'=>barMap.get('0110'),
                'G'=>barMap.get('0110'),
                'H'=>barMap.get('0110'),
                'I'=>barMap.get('1001'),
                'J'=>barMap.get('1001'),
                'K'=>barMap.get('1001'),
                'L'=>barMap.get('1001'),
                'M'=>barMap.get('1001'),
                'N'=>barMap.get('1001'),
                'O'=>barMap.get('1010'),
                'P'=>barMap.get('1010'),
                'Q'=>barMap.get('1010'),
                'R'=>barMap.get('1010'),
                'S'=>barMap.get('1010'),
                'T'=>barMap.get('1010'),
                'U'=>barMap.get('1100'),
                'V'=>barMap.get('1100'),
                'W'=>barMap.get('1100'),
                'X'=>barMap.get('1100'),
                'Y'=>barMap.get('1100'),
                'Z'=>barMap.get('1100')
            };
        }       
        return topBitsMap;
    }

    private Map<String,String[]> bottomBitsMap;
    public Map<String,String[]> getBottomMap()
    {
        if(bottomBitsMap==null)
        {
	    barMap = getBarMap();
            bottomBitsMap = new Map<String,String[]>{
                '0'=>barMap.get('0011'),
                '1'=>barMap.get('0101'),
                '2'=>barMap.get('0110'),
                '3'=>barMap.get('1001'),
                '4'=>barMap.get('1010'),
                '5'=>barMap.get('1100'),
                '6'=>barMap.get('0011'),
                '7'=>barMap.get('0101'),
                '8'=>barMap.get('0110'),
                '9'=>barMap.get('1001'),
                'A'=>barMap.get('1010'),
                'B'=>barMap.get('1100'),
                'C'=>barMap.get('0011'),
                'D'=>barMap.get('0101'),
                'E'=>barMap.get('0110'),
                'F'=>barMap.get('1001'),
                'G'=>barMap.get('1010'),
                'H'=>barMap.get('1100'),
                'I'=>barMap.get('0011'),
                'J'=>barMap.get('0101'),
                'K'=>barMap.get('0110'),
                'L'=>barMap.get('1001'),
                'M'=>barMap.get('1010'),
                'N'=>barMap.get('1100'),
                'O'=>barMap.get('0011'),
                'P'=>barMap.get('0101'),
                'Q'=>barMap.get('0110'),
                'R'=>barMap.get('1001'),
                'S'=>barMap.get('1010'),
                'T'=>barMap.get('1100'),
                'U'=>barMap.get('0011'),
                'V'=>barMap.get('0101'),
                'W'=>barMap.get('0110'),
                'X'=>barMap.get('1001'),
                'Y'=>barMap.get('1010'),
                'Z'=>barMap.get('1100')
            };
        }       
        return bottomBitsMap;
    }

    
}
