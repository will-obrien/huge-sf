/*
    Classe de testes para a classe: Validar_CPF_CNPJ
*/

@isTest
public class Validar_CPF_CNPJ_Teste{

    static testMethod void testeCPF(){
        System.assertEquals(true, Validar_CPF_CNPJ.validarCPF('814.406.038-55'));
        System.assertEquals(false, Validar_CPF_CNPJ.validarCNPJ('814.406.038-54'));
    }
    
    static testMethod void testeCNPJ(){
        System.assertEquals(true, Validar_CPF_CNPJ.validarCNPJ('84.006.571/0001-23'));
        System.assertEquals(false, Validar_CPF_CNPJ.validarCNPJ('84.006.571/0001-22'));    
    }

}