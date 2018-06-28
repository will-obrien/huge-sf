public class test {

    public String getIpAddress() {
        return apexpages.currentpage().getheaders().get('X-Salesforce-SIP');
    }
    
    

}