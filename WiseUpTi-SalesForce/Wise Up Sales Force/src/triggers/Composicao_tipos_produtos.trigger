/*
    Classe teste: Composicao_Teste
*/
trigger Composicao_tipos_produtos on Composicao_produto__c (after insert) {
    System.debug('___ [trg - Composicao_tipos_produtos] ..START..');
    if (!Composicao_produtos_Permissao__c.getOrgDefaults().Combos_itens_requeridos__c || !Composicao_produtos_Permissao__c.getOrgDefaults().Composicao_cascata__c) {
    
        Set<Id> paiIds = new Set<Id>();
        Set<Id> filhoIds = new Set<Id>();
        Map<String, String> paiFuncao = new Map<String, String>();
        Map<Id, Id> ids = new Map<Id, Id>();

        List<List<String>> itens = new List<List<String>>();
        List<String> funcoes = new List<String>{'Combo', 'Obrigatório'};
        
        String msgCascata = System.Label.Msg_composicao_cascata;
        String msgTipos = System.Label.Msg_combos_itens_requeridos;

        for (Composicao_produto__c comp : trigger.new){
            if (comp.Funcao__c == 'Combo' || comp.Funcao__c == 'Obrigatório') {
                List<String> lista = new List<String>();
                lista.add(comp.Id); 
                lista.add(comp.Produto_pai__c); 
                lista.add(comp.Produto_filho__c);
                itens.add(lista);
                
                paiIds.add(comp.Produto_pai__c);
                filhoIds.add(comp.Produto_filho__c);
                ids.put(comp.Produto_pai__c, comp.Id);
            }

            /* Tipos diferentes - Verifica nos registros em trigger.new */
            if (!Composicao_produtos_Permissao__c.getOrgDefaults().Combos_itens_requeridos__c){
                if (paiFuncao.get(comp.Produto_pai__c) <> null && paiFuncao.get(comp.Produto_pai__c) <> comp.Funcao__c){            
                    trigger.newMap.get(comp.Id).addError(msgTipos);
                    break;
                }else{
                    paiFuncao.put(comp.Produto_pai__c, comp.Funcao__c);
                }
            }
        }

        /* Tipos diferentes - Verifica nos registros em trigger.new */
        if (itens.size() > 0){
//            System.debug('___ Composicao_produtos_Permissao__c.getOrgDefaults().Composicao_cascata__c : '+ Composicao_produtos_Permissao__c.getOrgDefaults().Composicao_cascata__c);
  //          System.debug('___ itens : '+ itens);
            if (!Composicao_produtos_Permissao__c.getOrgDefaults().Composicao_cascata__c){
                System.debug('filhoIds.' + filhoIds);
                for (String s : paiIds){
                    System.debug(s);
                    if (filhoIds.contains(s)) {
                        trigger.newMap.get(ids.get(s)).addError(msgCascata);
                        break;
                    }
                }
            }
        
            /* Tipos diferentes - Verifica nos registros que já exitem */
            if (!Composicao_produtos_Permissao__c.getOrgDefaults().Combos_itens_requeridos__c) {
                for (Aggregateresult ar : [SELECT Funcao__c, COUNT(Produto_filho__c), Produto_pai__c 
                                           FROM Composicao_produto__c 
                                           WHERE Funcao__c IN : funcoes 
                                              AND Produto_pai__c IN : paiIds 
                                           GROUP BY Funcao__c, Produto_pai__c
                                           ORDER BY Produto_pai__c]){
                    System.debug('___ [trg - Composicao_tipos_produtos] ar : ' + ar);
                    if (paiFuncao.get((String) ar.get('Produto_pai__c')) <> null && paiFuncao.get((String) ar.get('Produto_pai__c')) <> (String) ar.get('Funcao__c')) {
                        trigger.newMap.get(ids.get((Id) ar.get('Produto_pai__c'))).addError(msgTipos);
                        break;
                    }else{
                        paiFuncao.put( (String) ar.get('Produto_pai__c'), (String)  ar.get('Funcao__c'));
                    }
                }
            }   
        
        
            /* Produto em cascata - Verifica nos registros que já exitem */
            if (!Composicao_produtos_Permissao__c.getOrgDefaults().Composicao_cascata__c) {        
                for (Composicao_produto__c composicao : [SELECT Id, Produto_pai__c, Produto_filho__c 
                                                         FROM Composicao_produto__c 
                                                         WHERE (Produto_Filho__c IN: paiIds 
                                                                OR Produto_pai__c IN : filhoIds)
                                                         AND Funcao__c IN : funcoes]){
                    List<String> lista = new List<String>();
                    lista.add(composicao.Id);
                    lista.add(composicao.Produto_pai__c);
                    lista.add(composicao.Produto_filho__c);
                    itens.add(lista);
                }
                System.debug('___ [itens] : ' + itens);
                for (Integer i = 0; i < itens.size() ; i++ ){
                    System.debug('___ [itens[i]] : '+ i + ' ' + itens[i]);
                    for (Integer j = i+1 ; j < itens.size() ; j++){ // j = i+1  porque a comparação é dentro da própria lista. Os itens antes não precisam ser passados, assim como não precisa comparar com ele mesmo
                        if (itens[i][1] == itens[j][2] || itens[i][2] == itens[j][1]){
                            trigger.newMap.get(itens[i][0]).addError(msgCascata);
                            break;
                        }
                    }
                }
            }
        }
    }
    System.debug('___ [trg - Composicao_tipos_produtos] ..END..');
}