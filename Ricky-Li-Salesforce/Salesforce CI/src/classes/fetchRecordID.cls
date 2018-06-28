public class fetchRecordID
{
    public List<String> obj = new List<String>();
    public List<String> fld = new List<String>();
    public string aniValue = ApexPages.currentPage().getParameters().get('ANI');
    public string completeURL = ApexPages.currentPage().getUrl();
    public string fieldValue;
    public List<Sobject> Ids = new Sobject[]{};
    public PageReference newPage;
    public string url;
    public string qryString;

    public fetchRecordID(){}

    public void searchANI()
    {
        aniValue = aniValue.deleteWhitespace();
        if(aniValue.length() == 11 && aniValue.startsWith('1'))
            aniValue = aniValue.removeStart('1');
        else if(aniValue.length() == 12 && aniValue.startsWith('+1'))
            aniValue = aniValue.removeStart('+1');
        url = '/search/SearchResults?searchType=2&str='+ aniValue;
        newPage = new PageReference(url);
        newPage.setRedirect(true);
    }

    public PageReference getRedirectURL()
    {
        Integer i,notnullindex;
        try
        {
             if(completeURL==null)
             {
                 return newPage;
             }
             else
             {
                 completeURL = completeURL.substringAfter('openpage?');
                 String[] tempURL = completeURL.split('vf_');
                 for(i = 1;i < tempURL.size(); i++) {
                     obj.add(tempURL[i].split('_')[0]);
                     fld.add(tempURL[i].split('_')[1]);
                 }

                 for(i = 0;i < fld.size();i++) {
                     fld[i] = fld[i].split('=')[0];
                 }
             }
             String urlParameter;
             for(i = 0;i < obj.size();i++) {
                 urlParameter = ApexPages.currentPage().getParameters().get('vf_'+obj[i]+'_'+fld[i]);
                 if(urlParameter.trim() != '' && urlParameter.trim() != 'null') {
                     notnullindex = i;
                     Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                     Schema.SObjectType leadSchema = schemaMap.get(obj[i]);
                     Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                     fieldValue = ApexPages.currentPage().getParameters().get('vf_'+obj[i]+'_'+fld[i]);
                     for (String fieldName: fieldMap.keySet()) {
                         Schema.DisplayType type = fieldMap.get(fieldName).getDescribe().getType();
                         if(fieldName == fld[i]) {
                             if(type == Schema.DisplayType.Phone && fieldValue.startsWith(' '))
                                 fieldValue = fieldValue.replaceFirst(' ','+');
                         }
                     }
                     break;
                 }
             }
             if(notnullindex != null) {
                 obj[notnullindex] = String.escapeSingleQuotes(obj[notnullindex]);
                 fld[notnullindex] = String.escapeSingleQuotes(fld[notnullindex]);
                 fieldValue = String.escapeSingleQuotes(fieldValue);
                qryString = 'SELECT Id FROM ' + obj[notnullindex] + ' WHERE ' + obj[notnullindex] + '.' + fld[notnullindex] + ' = ' + '\'' + fieldValue + '\'' ; 
                Ids = Database.query(qryString);
             }
             if (Ids.size()==0)
             {
                 searchANI();
             }
             if(Ids.size()==1)
             {
                  newPage = new PageReference('/' + Ids[0].id);
                  newPage.setRedirect(true);
             }
             else if(Ids.size()>1)
             {
                 url = '/search/SearchResults?searchType=2&str='+ fieldValue;
                 newPage = new PageReference(url);
                 newPage.setRedirect(true);
             }
        }
        catch(exception e)
        {
            if(aniValue<>null)
            {
                searchANI();
            }
        }
        return newPage;
    }
}