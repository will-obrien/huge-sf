/**
 * BingoController controls the BINGO page and both BINGO components.
 *
 * @author David Schach
 *
 * Dev Team Chris Shackelford
 *          Brad Gross
 *
 * @version     2.1 2011-02-18
 *  
 */

global with sharing class BINGOController {
    
    private id myid;
    public List<User> bingos {get; private set;}
    private List<User> allusers;
    private Set<Id> userids;
    public User me {get; set;}
    public User user1 {get; set;}
    public User user2 {get; set;}
    public User user3 {get; set;}
    public User user4 {get; set;}
    public User user5 {get; set;}
    public User user6 {get; set;}
    public User user7 {get; set;}
    public User user8 {get; set;}
    public User user9 {get; set;}
    public User user10 {get; set;}
    public User user11 {get; set;}
    public User user12 {get; set;}
    public User user13 {get; set;}
    public User user14 {get; set;}
    public User user15 {get; set;}
    public User user16 {get; set;}
    public User user17 {get; set;}
    public User user18 {get; set;}
    public User user19 {get; set;}
    public User user20 {get; set;}
    public User user21 {get; set;}
    public User user22 {get; set;}
    public User user23 {get; set;}
    public User user24 {get; set;}
    public User user25 {get; set;}
    
    //public List<User> bingousers {get; set;}
    
    private static final integer totalsquares = 25;
    
	private static final integer querylimit = 10000;
    
    /**
     * The constructor for BingoController
     */
    
    public BingoController(){
        myid = UserInfo.getUserId();
        userids = new Set<Id>();
        // Users Following Me
        for(EntitySubscription es : [select Id, ParentId, SubscriberId  from EntitySubscription WHERE ParentId = :myid LIMIT :querylimit]){
            userids.add(es.SubscriberId);
        }
        // Users I'm Following
        for(EntitySubscription es : [select Id, SubscriberId, ParentId  from EntitySubscription WHERE SubscriberId = :myid LIMIT :querylimit]){
            if( ('' + es.parentid).substring(0,3) == '005' ) // users only
                userids.add(es.ParentId);
        }     
        allusers = [SELECT id, smallphotourl, FullPhotoUrl, name FROM User where Id IN :userids ];
        Set<Integer> usedindices = new Set<Integer>();
        bingos = new List<User>();
        
        while(usedindices.size() < allusers.size() ){
            integer index =  math.round(Math.random()*(allusers.size()-1));
            //system.debug('INDEX VALUE: ' + index);
            if(!usedindices.contains(index)){
                usedindices.add(index);
                bingos.add(allusers[index]);
                if(usedindices.size() > totalsquares){ break; } // Break WHILE loop
            }           
        }
    
        me = [SELECT id, smallphotourl, FullPhotoUrl, name FROM User where Id = :myid   ];
                
        if (bingos.size() >= 1) {user1 = bingos[0];}
        if (bingos.size() >= 2) {user2 = bingos[1];}
        if (bingos.size() >= 3) {user3 = bingos[2];}
        if (bingos.size() >= 4) {user4 = bingos[3];}
        if (bingos.size() >= 5) {user5 = bingos[4];}
        if (bingos.size() >= 6) {user6 = bingos[5];}
        if (bingos.size() >= 7) {user7 = bingos[6];}
        if (bingos.size() >= 8) {user8 = bingos[7];}
        if (bingos.size() >= 9) {user9 = bingos[8];}
        if (bingos.size() >= 10) {user10 = bingos[9];}
        if (bingos.size() >= 11) {user11 = bingos[10];}
        if (bingos.size() >= 12) {user12 = bingos[11];}
        if (bingos.size() >= 13) {user13 = bingos[12];}
        if (bingos.size() >= 14) {user14 = bingos[13];}
        if (bingos.size() >= 15) {user15 = bingos[14];}
        if (bingos.size() >= 16) {user16 = bingos[15];}
        if (bingos.size() >= 17) {user17 = bingos[16];}
        if (bingos.size() >= 18) {user18 = bingos[17];}
        if (bingos.size() >= 19) {user19 = bingos[18];}
        if (bingos.size() >= 20) {user20 = bingos[19];}
        if (bingos.size() >= 21) {user21 = bingos[20];}
        if (bingos.size() >= 22) {user22 = bingos[21];}
        if (bingos.size() >= 23) {user23 = bingos[22];}
        if (bingos.size() >= 24) {user24 = bingos[23];}
        if (bingos.size() >= 25) {user25 = bingos[24];}
    }
    
    /**
     * Method getChooseRender
     *
     * @return String
     */
    
    public String getChooseRender() {
    	if (ApexPages.currentPage().getParameters().get('p') != null) return 'pdf';
        else return null;
    }
    
    /**
     * Method showAsPDF navigates to the same Visualforce page, but flushes the cache and 
     * performs a GET.  It also places the 'p' parameter in the URL, so ChooseRender
     * returns 'pdf' to the page RenderAs attribute.
     * Note: This also reshuffles the BINGO card, so this does NOT merely display the current
     * BINGO card as a pdf.
     *
     * @return PageReference
     */
    
    public PageReference showAsPDF() {
        PageReference pdfPage =  ApexPages.currentPage();
        pdfpage.getParameters().put('p','p');
        pdfpage.setRedirect(true);
        return pdfpage;
    }
    
    /**
     * Method NewCard navigates to the same Visualforce page, but flushes the cache and 
     * performs a GET.  It does NOT place any 'p' parameter in the URL, so the new page
     * renders as html.  This effectively reshuffles the BINGO card.
     *
     * @return PageReference
     */    
    
    public PageReference NewCard(){
        PageReference pageRef = Page.BINGO;
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
     * Method deprecated, now that renderAs is included in Page.BINGO.
     */
    /*
    public PageReference MakePDF(){
        PageReference pageRef = Page.BINGO_PDF;
        pageRef.setRedirect(false);
        return pageRef;
    }
    */
    
    /**
     * TestMethod - inserts 30 users, has them each follow the running user, 
     * and renders the BINGO card.
     */
    private static  TestMethod void testBINGO_30(){
        
        List<User> users = new List<User>();
        
        for(integer i = 0; i<30; i++)   {
            User u = createTestUser(getSuperProfile());
            users.add(u);
        }
        insert users;
        List<EntitySubscription> followers = new List<EntitySubscription>();
        for ( user u : users){
            EntitySubscription es = new EntitySubscription(SubscriberId = u.id, ParentId = UserInfo.getUserId());
            followers.add(es);
        }
        insert followers;
        
        test.starttest();
        Test.setCurrentPage(Page.Bingo);
      
        BINGOController controller = new BINGOController();
        String NewCard = controller.NewCard().getUrl();
        System.assertEquals('/apex/bingo', NewCard);
        
        String CardPDF = controller.showAsPDF().getUrl();
        System.assertEquals('/apex/bingo?p=p', CardPDF);    
        test.stoptest();
    }
    
     /**
     * TestMethod - inserts 2 users, has them each follow the running user, 
     * and renders the BINGO card.
     * It also has the running user follow each of the 2 inserted users.
     * This is because the BINGO card draws from a user's followers and 
     * from those users who follow the user.
     */
    
    private static  TestMethod void testBINGO_2(){
        
        List<User> users = new List<User>();
        
        for(integer i = 0; i<2; i++)    {
            User u = createTestUser(getSuperProfile());
            users.add(u);
        }
        insert users;
        List<EntitySubscription> followers = new List<EntitySubscription>();
        for ( user u : users){
            EntitySubscription es = new EntitySubscription(SubscriberId = u.id, ParentId = UserInfo.getUserId());
            followers.add(es);
        }
        insert followers;
        
        followers = new List<EntitySubscription>();
        for (user u : users){
        	EntitySubscription es = new EntitySubscription(SubscriberId = UserInfo.getUserId(), ParentId = u.id);
        	followers.add(es);
        }
        insert followers;
        
        test.starttest();
        Test.setCurrentPage(Page.Bingo);
      
        BINGOController controller = new BINGOController();
        String NewCard = controller.NewCard().getUrl();
        System.assertEquals('/apex/bingo', NewCard);
        String CardPDF = controller.showAsPDF().getUrl(); 
        System.assertEquals('/apex/bingo?p=p', CardPDF);    
        test.stoptest();
    }
    
     /**
     * TestMethod - inserts 0 users, has them each follow the running user, 
     * and renders the BINGO card.
     * This method also verifies that the card is first shown as a html page, not a pdf.
     */
    private static  TestMethod void testBINGO_0(){
        
        test.starttest();
        Test.setCurrentPage(Page.Bingo);
      
        BINGOController controller = new BINGOController();
        System.assertEquals(null, controller.getChooserender()); //We are not making a PDF
        String NewCard = controller.NewCard().getUrl();
        System.assertEquals('/apex/bingo', NewCard);
        String CardPDF = controller.showAsPDF().getUrl();
        System.assertEquals('/apex/bingo?p=p', CardPDF);  
        
        test.stoptest();
    }
    
     /**
     * TestMethod - inserts 0 users, has them each follow the running user, 
     * and renders the BINGO card as a PDF.
     */
    private static TestMethod void testShowAsPDF(){
    	test.starttest();
        Test.setCurrentPage(Page.Bingo);
      	ApexPages.currentPage().getParameters().put('p', 'p');
        BINGOController controller = new BINGOController();
        System.assertEquals('pdf', controller.getChooserender()); //We are making a PDF
        test.stoptest();
    }
    
    public Static Profile TheProfile;
    
    /**
     * Helper method to find a ModifyAllData user profile for each of the test users we create.
     * @return Profile
     */
    
    public Static Profile getSuperProfile(){
        if (TheProfile == null){
            for( Profile p : [ Select Id, PermissionsModifyAllData, Name from Profile limit 100 ] ){
                if( p.PermissionsModifyAllData ){
                    TheProfile = p;
                    return TheProfile;
                }
            }
        }
        return TheProfile;
    }
    
    
    // All code below adapted from ActionPlans, written by Matias Menafra
  
    /**
    * Creates a new User
    * @return testUser
    */
 
    public Static  User createTestUser( Profile p ) {

        //USER U = [ SELECT ID FROM USER WHERE ID = :USERINFO.GETUSERID()];
        //RETURN U;
    
        String namePrefix = createRandomWord();
    
        User testUser = new User();
        testUser.Email              = 'test@test.com';
        testUser.Username           = namePrefix + '@testuser.com';
        testUser.LastName           = 'test';
        testUser.Alias              = 'test';
        testUser.ProfileId          = p.Id;
        testUser.LanguageLocaleKey  = 'en_US';
        testUser.LocaleSidKey       = 'en_US';
        testUser.TimeZoneSidKey     = 'America/Chicago';
        testUser.EmailEncodingKey   = 'UTF-8';
        
        //insert testUser;
        
        return testUser;
    }
    /**
    * Random words are required for testing 
    * as you will likely run into any word I can insert
    * during a test class and produce false test results.
    */
    public Static  String createRandomWord() {
      
      String ret = 'schach' + math.rint(math.random() * 100000);
      
      return ret;
    }
}