global class Utilities
{
    public Static User objUser = null;
    
    public static User getCurrentUserDetails()
    {
        if(objUser!= null) return objUser;
        Id currentUSer = userinfo.getuserid();
        
        system.debug('* * * currentUSer ...'+ currentUSer);
        
        return [select id,email,username,Contactid from user where id =: currentUSer];
    }
    

}