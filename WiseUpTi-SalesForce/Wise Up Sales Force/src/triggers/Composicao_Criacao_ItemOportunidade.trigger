/*
    Data 15/08/2015
    after-insert para respeitar regras da org
    
    Rotina que insere em cascata ps registros filhos indicados na composição do produto.
    Quando a composição é do tipo 'Combo', o registro pai é excluído da opotunidade.   

    Classe teste: Composicao_Teste
*/

trigger Composicao_Criacao_ItemOportunidade on OpportunityLineItem (after insert) {
    
    System.debug('__ [trg Composicao_Criacao_ItemOportunidade (after insert)] ..START..');
    System.debug('__ [trg Composicao_Criacao_ItemOportunidade (after insert)] - trigger.new.size() : ' + trigger.new.size());
    List<String> mensagem = new List<String>();
     mensagem = Composicao_Criacao.ItensOli(trigger.new);

    System.debug('__ [trg Composicao_Criacao_ItemOportunidade (after insert)] - mensagem : ' + mensagem );
    if (mensagem.size() > 0) {
        System.debug('__ [trg Composicao_Criacao_ItemOportunidade (after insert)] - ..OUT.. ');
        trigger.newMap.get(mensagem[0]).addError(mensagem[1]);
//        break;
    }

    System.debug('__ [trg Composicao_Criacao_ItemOportunidade (after insert)] trigger.new : ' + trigger.new);
    System.debug('__ [trg Composicao_Criacao_ItemOportunidade (after insert)] ..END..');  
}