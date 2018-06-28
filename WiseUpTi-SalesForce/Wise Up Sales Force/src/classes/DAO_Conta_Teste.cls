/*
    Classe de testes para a classe: DAO_Conta
*/

@isTest
public class DAO_Conta_Teste{

    static testMethod void teste(){
        Account conta = Teste_Util.newAccount();
        conta.PersonEmail = 'email@email.com';
        update conta;
        
        Map<String, String> retorno = DAO_Conta.recuperaEmail(new List<String>{conta.PersonEmail});
        
        System.assertEquals(retorno.get(conta.PersonEmail), conta.Id);
    }

}