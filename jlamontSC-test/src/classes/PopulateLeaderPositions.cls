public with sharing class PopulateLeaderPositions {
	public void populate() {
		Set<String> adminPosSet = new Set<String>();
		adminPosSet.add('AMSO');
		adminPosSet.add('ASDI');
		adminPosSet.add('CCO');
		adminPosSet.add('CHDI');
		adminPosSet.add('CHR');
		adminPosSet.add('DDIR');
		adminPosSet.add('DRCT');
		adminPosSet.add('LEGA');
		adminPosSet.add('LEGS');
		adminPosSet.add('MOS');
		adminPosSet.add('NEWS');
		adminPosSet.add('OUTG');
		adminPosSet.add('SADM');
		adminPosSet.add('SCON');
		adminPosSet.add('SGRP');
		adminPosSet.add('SLOB');
		adminPosSet.add('WBMR');
		List<Leader_Position__c> posUpdt = new List<Leader_Position__c>();
		List<Leader_Position__c> posList = [
			select
				Id,
				Code__c, 
				ClubEventPermission_NonOutings__c, 
				ClubEventPermission_Outings__c
			from Leader_Position__c 
		];
		for(Leader_Position__c pos : posList) {
			if(pos.Code__c == 'RECM') {
				pos.ClubEventPermission_Outings__c = 'Administrator';
			}
			else if(pos.Code__c == 'AMS') {
				pos.ClubEventPermission_NonOutings__c = 'Administrator';
			}
			else if(adminPosSet.contains(pos.Code__c)) {
				pos.ClubEventPermission_NonOutings__c = 'Administrator';
				pos.ClubEventPermission_Outings__c = 'Administrator';
			}
			else {
				pos.ClubEventPermission_NonOutings__c = 'Standard';
			}
			posUpdt.add(pos);					
		}
		update posUpdt;
	}
}