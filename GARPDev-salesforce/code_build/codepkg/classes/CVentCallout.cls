global class CVentCallout{

    public List<String> a { get; set; }

    @future(callout=true)
    public static void GetCVentData() {
        
		// Create the stub
        apiCventCom200611.GetUpdatedResponse_element getUpdatedElem = new apiCventCom200611.GetUpdatedResponse_element();

		// Authenticate        
        apiCventCom200611.Login_element loginElem = new apiCventCom200611.Login_element();
        loginElem.AccountNumber = 'GARPNJ001';
        loginElem.UserName = 'GARPNJ001Api';
        loginElem.Password = 'dRIbVruUHc';

        schemasCventComApi200611.LoginResult loginResult = new schemasCventComApi200611.LoginResult();
        
        //loginResult = apiCventCom200611.V200611Soap.Login('GARPNJ001','GARPNJ001Api','dRIbVruUHc'); 
        
        apiCventCom200611.V200611Soap soap = new apiCventCom200611.V200611Soap();
        loginResult = soap.Login('GARPNJ001','GARPNJ001Api','dRIbVruUHc');
        
        system.debug('* * * Login: ' + loginResult);
        
    }
}