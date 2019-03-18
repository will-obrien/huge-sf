public class UserDAO {
    public static User userSistema;
    public static List<User> listAllUsers;
    
    public static User getUsuarioSistema(){
        
        if(userSistema == null){
            userSistema = [SELECT Id, Name FROM User WHERE Name = 'Sistema'];
        }
        
        return userSistema;
    }
    
    public static List<User> listAllUsers(){
        if(listAllUsers == null){
            listAllUsers = [SELECT Id, Name, UserRole.Name, UserRole.Id, CompanyName, Department FROM User ];
        }
        return listAllUsers;
    }
    
    public static map<Id, User> mapUsersByDepartmentAndCompanyName(String Department, String CompanyName){
        
        map<Id, User> mapUsers = new map<Id, User>();
        
        for(User u : [SELECT Id, Name, UserRole.Name, UserRole.Id, CompanyName, Department FROM User WHERE Department =: Department AND CompanyName =: CompanyName ORDER BY Name]){
            mapUsers.put(u.Id, u);
        }
        
        return mapUsers;
    }
    
    public static map<Id, User> mapUsersByDepartmentsAndCompanyNames(List<String> Departments, List<String> CompanyNames){
        
        map<Id, User> mapUsers = new map<Id, User>();
        
        for(User u : [SELECT Id, Name, UserRole.Name, UserRole.Id, CompanyName, Department FROM User WHERE Department IN: Departments AND CompanyName IN: CompanyNames ORDER BY Name]){
            mapUsers.put(u.Id, u);
        }
        
        return mapUsers;
    }
    
    public static List<User> listUsersByDepartmentAndCompanyName(String Department, String CompanyName){        
        return [SELECT Id, Name, UserRole.Name, UserRole.Id, CompanyName, Department FROM User WHERE Department =: Department AND CompanyName =: CompanyName ORDER BY Name];
        
    }
    
    public static List<User> listUsersByDepartmentsAndCompanyNames(List<String> Departments, List<String> CompanyNames){        
        return [SELECT Id, Name, UserRole.Name, UserRole.Id, CompanyName, Department FROM User WHERE Department IN: Departments AND CompanyName IN: CompanyNames ORDER BY Name];
        
    }
    
    public static User getDiretorComercial(Id idUsuarios){        
        return [SELECT Id, Contact.Account.Diretor_comercial__c FROM User WHERE Id =: idUsuarios];
    }
}