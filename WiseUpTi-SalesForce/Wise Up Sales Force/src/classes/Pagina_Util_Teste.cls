/*
    Classe de testes para a classe: Pagina_Util
*/

@isTest
public class Pagina_Util_Teste{

    static testMethod void teste(){
        Pagina_Util.showError('erro');
        
        Pagina_Util.showConfirm('sucesso');
    }

}