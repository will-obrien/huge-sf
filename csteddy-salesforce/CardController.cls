@RestResource(urlMapping='/Cards/*')
global class CardController {

    @HttpGet
/*
    global static List<Card__c> getCards() {
        List<Card__c> Cards = [SELECT Name from Card__c];
        return Cards;
*/
    global static String validator() {
    return '31bfec673739a7ff23b13b341d4a0d521a8137b8';
    }

    @HttpPost 
    global static String createNewCard(String Name) {
        Card__c w = new Card__c();
        w.Name = Name;
        insert w;

        return 'Done';
   }

    @HttpDelete
    global static String deleteCardById() {
        String Id = RestContext.request.params.get('Id');
        List<Card__c> w = [ Select ID from Card__c where Id= :Id];

        delete w;

        return 'Deleted Card';
    }

    @HttpPut
    global static String updateCard(String Id, String NewName) {
        Card__c w = [ Select ID, Name from Card__c where Id= :Id];

        w.Name = NewName;
        update w;

        return 'Card Updated';
    }
}
