/*
    Classe de testes: Validar_CNPJ_Conta_Teste
*/

trigger Validar_CNPJ_Conta on Account(after insert, after update){

    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        for(Account a : trigger.new){
            if(String.isNotEmpty(a.CNPJ__c) && (trigger.isInsert || a.CNPJ__c != trigger.oldMap.get(a.Id).CNPJ__c)){
                if(!Validar_CPF_CNPJ.validarCNPJ(a.CNPJ__c)) a.addError(System.Label.CNPJ_invalido);
            }
        }
    }

}