public class wrapMenu {
        public Menu__c mnu{get; set;}
        public Boolean selectedList {get; set;}
        public  wrapMenu (Menu__c  m) {
            mnu= m;
            selectedList = false;
        }
    }