/*
    Classe de testes: Validar_CPF_Contato
*/

trigger Validar_CPF_Contato on Contact (after insert, after update){

    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        for(Contact c : trigger.new){
            if(String.isNotEmpty(c.CPF__c) && (trigger.isInsert || c.CPF__c != trigger.oldMap.get(c.Id).CPF__c)){
                if(!Validar_CPF_CNPJ.validarCPF(c.CPF__c)) c.addError(System.Label.CPF_invalido);
            }
        }
    }
}