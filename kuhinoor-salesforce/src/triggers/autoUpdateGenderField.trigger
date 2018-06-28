trigger autoUpdateGenderField on Contact (before insert,before update) {
    for(contact con : Trigger.new){
        if('Mr.' == con.Salutation){
            con.Gender__c='Male';
        }
        else if('Mrs.' == con.salutation || 'Ms.' == con.salutation){
            Con.Gender__c = 'Female';
        }
       
    }
}