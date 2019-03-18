@isTest
public class ImageSliderControllerTest {
	@isTest
    static void getImagesTest() {
        Account account = new Account();
        account.Name = 'test account';
        insert account;
        
        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.LastName = 'Test';
        contact.FirstName = 'url1';
        insert contact;
        
        List<string> imageUrls = ImageSliderController.getImages(account.Id, 'Contact', 'FirstName', 'AccountId');
        
        system.assertEquals(imageUrls.size(), 1);
        system.assertEquals(imageUrls[0], 'url1');
        
    }
}