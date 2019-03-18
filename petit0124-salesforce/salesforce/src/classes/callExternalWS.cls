Public class callExternalWS  
{  
    public void invokeExternalWs()  
    {  
        
        apiZuoraCom.LoginResult lr = new apiZuoraCom.LoginResult();
        apiZuoraCom.SOAP soap = new apiZuoraCom.SOAP();
        apiZuoraCom apiZuora = new apiZuoraCom();
        
        lr=soap.login('xucong.chen@zuora.com','Cxc198201241');
        System.debug(lr.Session);
        
         
        apiZuoraCom.QueryResult qr = new apiZuoraCom.QueryResult();
        apiZuoraCom.SessionHeader_element  sessionHeader = new apiZuoraCom.SessionHeader_element();
        sessionHeader.session=lr.Session;
        soap.SessionHeader =sessionHeader;
        qr=soap.query('select id from Account');
        List<objectApiZuoraCom.zObject > records = new List<objectApiZuoraCom.zObject>();
        records=qr.records;
        

   
    }  
}