public class CameraAccess{
    public ContentVersion cont {get;set;}

    public CameraAccess() {
        cont = new ContentVersion();
    }      

    public PageReference saveFile()
    {
        //PathOnClient is Mandatory
        cont.PathOnClient = cont.title;

        //By default Origin value is "C" that means Content must be enabled in Org, so we need to explicitly set Origin as H
        cont.Origin = 'H';
        insert cont;

        //redirect to path where file is saved
        return new PageReference('/'+cont.id);
    }
}