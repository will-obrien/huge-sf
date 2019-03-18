/*
    after-update para respeitar regras da org

    Referente as alterações em cadeia.
        Quantidade de um item combo - atualiza todos os itens do mesmo combo
        Quantidade de um item requerido - permite alteração conforme configuração
        Valor de item requerido - Nunca permite alteração
        Valor de um item combo - Nunca permite alteração
    
    Classe teste: Composicao_Teste
*/
trigger Composicao_Alteracao_ItemOportunidade on OpportunityLineItem (after update) {

        /*  INICIO
          Não permite alterar:
            quantidade de itens requeridos
            quantidade de itens filhos de algum combo
            valor de itens filhos de algum combo
        */
        
        Set<id> ids = new Set<Id>();
        Set<String> itensCombo = new Set<String>();
        Map<String, Decimal> novaQtde = new Map<String, Decimal>();
        Map<String, Decimal> porcentValor = new Map<String, Decimal>();
        List<OpportunityLineItem> oppLItemNew = new List<OpportunityLineItem>();
        Boolean updateItem = false;

    String msgItensRequeridos = 'Não pode alterar itens requeridos';
    String msgValorCombo = 'Não pode alterar valor do combo';
    
    System.debug('___ [trg Composicao_Alteracao_ItemOportunidade ] ..START.. ');
    System.debug('___ [trg Composicao_Alteracao_ItemOportunidade ] trigger.new ' + trigger.new);
    System.debug('___ [trg Composicao_Alteracao_ItemOportunidade ] trigger.old ' + trigger.old); 
        
        
    for (OpportunityLineItem oli:  trigger.new){

        //-- Alteração na quantidade do item --//
        if (oli.funcao__c != null && oli.funcao__c <> '' && oli.Quantity <> trigger.oldMap.get(oli.Id).Quantity){
            if (oli.funcao__c.contains('Requerido')){
                trigger.newMap.get(oli.Id).addError(msgItensRequeridos);
                break;
            }
            else{
                trigger.newMap.get(oli.Id).addError('Não é possível alterar a quantidade de um item que faz parte de um combo! Combo : ' + oli.funcao__c + '.');
                break;
            }
        }
            
        //-- Somente quando houver alteração no valor de venda do item --//
        System.debug('___[trg Composicao_Alteracao_ItemOportunidade ] oli.UnitPrice: '+ oli.UnitPrice);
        System.debug('___[trg Composicao_Alteracao_ItemOportunidade ] trigger.oldMap.get(oli.id).UnitPrice: '+ trigger.oldMap.get(oli.id).UnitPrice);
        System.debug('___[trg Composicao_Alteracao_ItemOportunidade ] funcao__c : '+ oli.funcao__c);
        if( (oli.funcao__c <> '' && oli.funcao__c <> null ) && oli.UnitPrice.setScale(5) <> trigger.oldMap.get(oli.id).UnitPrice.setScale(5)){
            if (oli.funcao__c.contains('Requerido')){     //-- Requerido nunca pode alterar valor --//
                //trigger.newMap.get(oli.Id).addError('Não é possível alterar o valor de um item requerido.');
                break;
            }
            else{
                    //-- Itens do combo nunca pode alterar valor --//
                System.debug('___[trg Composicao_Alteracao_ItemOportunidade ] deletando__c : '+ oli.Deletando__c);
                System.debug('___[trg Composicao_Alteracao_ItemOportunidade ] funcao__c : '+ oli.funcao__c);
                System.debug('___[trg Composicao_Alteracao_ItemOportunidade ] produto : '+ oli.Name);
                //trigger.newMap.get(oli.Id).addError( msgValorCombo + ' ' + oli.funcao__c + '.');
                break;
            }
        }
    } // fim do laço-for (OpportunityLineItem oli:  trigger.new){
    System.debug('___ [trg Composicao_Alteracao_ItemOportunidade ] ..END.. ');    

}