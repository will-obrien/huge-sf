/*
    Classe de testes: Validar_CPF_Conta
*/

trigger Validar_CPF_Conta on Account (before insert, before update){

    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        for(Account c : trigger.new){
            if(String.isNotEmpty(c.CPF__pc) && (trigger.isInsert || c.CPF__pc != trigger.oldMap.get(c.Id).CPF__pc)){
                if(!Validar_CPF_CNPJ.validarCPF(c.CPF__pc)) c.addError(System.Label.CPF_invalido);
            }
        }
    }
}