/*
Esse campo é gerado e não é o código fonte real para essa
classe global gerenciada.
Esse arquivo somente leitura mostra os construtores globais de classe,
métodos, variáveis e propriedades.
Para permitir a compilação do código, todos os métodos retornam nulo.
*/
global class Cielo_Util {
    global Cielo_Util() {

    }
    global static Id converteLead(Lead pageLead, String lSource, String oppNome) {
        return null;
    }
    global static System.HttpRequest getReqCancelamento(afinancecielo__Integracao_Cielo__c dadosEmpresa, afinancecielo__Transacao_Cielo__c tc) {
        return null;
    }
    global static System.HttpRequest getReqConsulta(afinancecielo__Integracao_Cielo__c dadosEmpresa, String Id, String TID) {
        return null;
    }
    global static System.HttpRequest getReqToken(afinancecielo__Integracao_Cielo__c dadosEmpresa, String nome, String numero, String validade, String trId) {
        return null;
    }
    global static System.HttpRequest getReqTransacao(afinancecielo.Cielo_Util.Cielo clo, afinancecielo__Integracao_Cielo__c dadosEmpresa) {
        return null;
    }
    global static afinancecielo__Transacao_Cielo__c integraCielo(System.HttpRequest req, afinancecielo__Transacao_Cielo__c rTC, String retornoTeste) {
        return null;
    }
    global static System.HttpResponse resTeste(String tipoDeRetorno) {
        return null;
    }
global class Cielo {
    global afinancecielo__Cartao__c cartao {
        get;
        set;
    }
    global String CID {
        get;
        set;
    }
    global afinance__Payment_Option__c CP;
    global String nomeCartao {
        get;
        set;
    }
    global String numeroPedido;
    global afinance__Transaction__c TR;
    global Cielo() {

    }
}
global class pagException extends Exception {
}
}
