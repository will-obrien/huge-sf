global with sharing class JRA_PostInstallScript implements system.InstallHandler {
/*
PNC June 2015
Invoked on installation of package
Currently, only set to run on new installation. Code snipped in comments can be used if need to run code on update
*/

global void onInstall(InstallContext context) {
	if(context.previousVersion() == null) {
		JRA_SetupCustomSettings.createSettings();
	}

	//else sif(context.previousVersion().compareTo(new Version(6,5)) < 0) {//Earlier than 6,5
	//	KWD_PopulateCustomSetting.createKeySetting();
	//}

	}

  
} //end class