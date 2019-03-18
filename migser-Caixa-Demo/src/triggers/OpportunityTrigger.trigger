trigger OpportunityTrigger on Opportunity (after insert) {
    
  System.debug('Iniiando Trigger');
// Listas de miembors a insertar, opps para actualizar y links para insertar
    List<CampaignMember> ins_members = new List<CampaignMember>();
  List<Opportunity> upd_opps = new List<Opportunity>();
  List<ContentDocumentLink> ins_links = new List<ContentDocumentLink>();
  List<Attachment> ins_atts = new List<Attachment>();

// IDs y Opps
    Set<ID> ids = Trigger.newMap.keySet();
    List<Opportunity> opps = [SELECT Id, name, accountid, CampaignId , Producto__c,ownerid, recordtypeid
                              FROM Opportunity WHERE 
                              id in :ids];
//IDs de Accounts y Campañas
    Set<ID> acc_ids = new Set<ID>();
    Set<ID> camp_ids = new Set<ID>();
//Generamos las listas de IDs
  for (Opportunity o : opps) {
        acc_ids.add(o.AccountId);
      camp_ids.add(o.CampaignId);
    }
//Generamos los Maps de Accounts y Campañas y la lista de miembros actual
    Map<ID, Account> accounts = new Map<ID, Account>([SELECT Id, PersonContactId
                                                         FROM Account where id in :acc_ids]);

  Map<ID, Campaign> campanas = new Map<ID, Campaign>([SELECT Id, campaign_product__c
                             FROM Campaign
                             where id in :camp_ids]);
  List<CampaignMember> curr_member = [select id, contactid, campaignid 
                                      from CampaignMember
                                      where campaignid in :camp_ids];
  List<ContentDocumentLink> camp_links = [SELECT LinkedEntityId, ContentDocumentId ,ShareType
                                            FROM ContentDocumentLink 
                                            WHERE LinkedEntityId in :camp_ids];
  List<Attachment> camp_attachments = [select parentid, name, body, contenttype
                                      from attachment
                                      where parentid in :camp_ids];

//Bucle principal de Opps
    for(Opportunity o : opps){
        System.debug('Creando Miembros  de la campaña ');

        String campana = o.CampaignId;
        String cuenta = o.AccountId;
        String contacto = accounts.get(cuenta).PersonContactId;
        System.debug('Campaña: ' + campana);
        System.debug('Cuenta: ' + cuenta);
        System.debug('Contacto: ' + contacto);


        if (campana!=null) {
      String producto = campanas.get(campana).campaign_product__c;
      System.debug('Producto: ' + producto);
      if (contacto!=null) {
                CampaignMember cm=new CampaignMember(CampaignId=campana,contactId=contacto,Status='Added'); 
          if (!existe(contacto, curr_member)) {
            ins_members.add(cm);
          }
      } 
      //Generando lista de attachments
      for (ContentDocumentLink cdl : camp_links) {
        if (cdl.LinkedEntityId == campana) {
        ContentDocumentLink link = new ContentDocumentLink(LinkedEntityId = o.id,
                                                           ContentDocumentId=cdl.ContentDocumentId,
                                                           ShareType=cdl.sharetype);
        ins_links.add(link);
        }
       }
          o.Producto__c = producto;
          upd_opps.add(o);
      
      //  update o;
      //  System.debug('El record type del registro es... '+o.recordtypeid);
      //  if (o.recordtypeid =='01258000000apAXAAY') {    
      for (Attachment a : camp_attachments) {    
        if (a.parentid == campana) {
          Attachment att = new Attachment(name = a.name, body = a.body, 
          parentid = o.Id, contenttype=a.contenttype, isprivate=false, ownerid=o.ownerid);
       //  insert att;
          ins_atts.add(att);
        }
      }
        //}
        }
   }

   update upd_opps;
   insert ins_atts;
   insert ins_members;
   insert ins_links;

   public static boolean existe( String contacto, List<CampaignMember> miembros) {
      boolean esta = false;
      for (CampaignMember cm : miembros) {
        if (cm.contactid==contacto) {
          esta = true;
          break;
        }
      }

    return esta;
   }

}