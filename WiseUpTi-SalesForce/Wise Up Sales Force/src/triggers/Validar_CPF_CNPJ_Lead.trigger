/*
    Classe de testes: Validar_CPF_CNPJ_Lead_Teste
*/

trigger Validar_CPF_CNPJ_Lead on Lead (after insert, after update){

    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        for(Lead l : trigger.new){
            if(String.isNotEmpty(l.CPF__c) && (trigger.isInsert || l.CPF__c != trigger.oldMap.get(l.Id).CPF__c)){
                if(!Validar_CPF_CNPJ.validarCPF(l.CPF__c)) l.addError(System.Label.CPF_invalido);
            }
            
            if(String.isNotEmpty(l.CNPJ__c) && (trigger.isInsert || l.CNPJ__c != trigger.oldMap.get(l.Id).CNPJ__c)){
                if(!Validar_CPF_CNPJ.validarCNPJ(l.CNPJ__c)) l.addError(System.Label.CNPJ_invalido);
            }
        }
    }

}