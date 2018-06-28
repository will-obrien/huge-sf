global class Voiture_Ajax {

	webService static Voiture__c saveVoiture(String nom, String reference, String couleur, String prix) { 
        Voiture__c voiture = new Voiture__c(
        	Nom__c = nom,
        	Reference__c = reference,
        	Couleur__c = couleur,
        	Prix__c = Decimal.valueOf(prix)
        );
        
        insert voiture;
        
        return voiture;
    }
}