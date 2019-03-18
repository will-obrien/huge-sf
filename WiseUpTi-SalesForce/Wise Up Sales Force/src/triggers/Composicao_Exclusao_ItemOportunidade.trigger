/* 
    Data 15/08/2015
    after-delete para respeitar regras da org
    
    Rotina que exclui em cascata os registros filhos na composição do produto.
    OpportunityLineItem.Id_Item_pai__c: campo referencia o pai, usado para sucesso na exclusão em cascata.

    Classe teste: Composicao_Teste
*/

trigger Composicao_Exclusao_ItemOportunidade on OpportunityLineItem (after delete) {
    Set<Id> oppLItemAll = new Set<Id>();
    List<OpportunityLineItem> oppLItemOld = new List<OpportunityLineItem>();
    Set<Id> oliPai = new Set<Id>();
    Map<Id, Decimal> opItensMap = new Map<Id, Decimal>();
    System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - ..START.. ');
    for (OpportunityLineItem oli : trigger.old){
        //if (oli.Funcao__c <> null && oli.Funcao__c <> ''){
            if (opItensMap.get(oli.OpportunityId) <> null) {
                opItensMap.put(oli.OpportunityId, opItensMap.get(oli.OpportunityId) + oli.Quantity);
            } else {
                opItensMap.put(oli.OpportunityId, oli.Quantity);
            }
        //}
    }

    System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - opItensMap : ' + opItensMap);
    if (opItensMap.size() > 0) {

        for (OpportunityLineItem oli: trigger.old){
            System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - ID : ' + oli.Id);

            //-- não permitir excluir manualmente itens mandatórios  --//
            System.debug('@@ '+ Trigger.oldMap.keyset().contains(oli.Id_Item_pai__c));
            System.debug('@@ '+ Trigger.oldMap);
            if (oli.Funcao__c <> null && oli.Funcao__c.contains('Requerido') && oli.Deletando__c == false &&
                            !Trigger.oldMap.keyset().contains(oli.Id_Item_pai__c)
            ){
                System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - Não excluir requerido - oli.Funcao__c : ' + oli.Funcao__c);
                oli.addError('Este item é ' + oli.Funcao__c + ', não pode ser excluído.');
                break;
            }
            else{
                //-- Acrescentar no oliPai os Ids que serão procurados (filtro para o campo Id_Item_pai__c)  --//
                oliPai.add(oli.Id);
            
                if (!oli.Deletando__c && oli.Id_Item_Pai__c <> null) {
                    //somente junta o pai do item que está sendo cancelado quando for o primeiro deletando
                    oliPai.add(oli.Id_Item_pai__c); 
                }
           }
           //-- oppLItemAll para os itens que não entrarão no select (ativaram a trigger)
           oppLItemAll.add(oli.Id);
        }

        //-- se não tiver valor para o select --//
        if (oliPai.size() == 0){
            System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - ..OUT.. ');
            System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - OUT: oliPai vazio ');
            return;
        }

        System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - (para select IN) oliPai : ' + oliPai );
        System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - (para select NOT IN) oppLItemAll : ' + oppLItemAll); 

        for(OpportunityLineItem oli: [SELECT Id, Id_Item_pai__c, Deletando__c, OpportunityId, Funcao__c FROM OpportunityLineItem WHERE Deletando__c = False AND Id_Item_pai__c IN : oliPai AND Id NOT IN : oppLItemAll]){
            //-- avisar que estao sendo excluidos por serem filhos  --//
            oli.Deletando__c = True;
            oppLItemOld.add(oli);
        }
    
        //-- Se houver retorno no select / Se houver itens filhos para exclusão --//
        System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - oppLItemOld.size() '+ oppLItemOld.size());
        if (oppLItemOld.size() > 0 ){
            update oppLItemOld; //update para o campo Deletando__c (que informa que está sendo excluído por um pai)
            System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - deleta todos: oppLItemOld: '+ oppLItemOld);
            delete oppLItemOld;
        }
    }
    System.debug('___ [trg Composicao_Exclusao_ItemOportunidade(after delete)] - ..END.. ');
   
}