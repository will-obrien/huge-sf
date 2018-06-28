trigger validationPhoneAndMobile on Contact (before insert,before update) {
    for(Contact con : Trigger.new){
        if(con.Phone == con.MobilePhone){
                con.Phone.addError('Please use different mobile number');
        }
    }
}