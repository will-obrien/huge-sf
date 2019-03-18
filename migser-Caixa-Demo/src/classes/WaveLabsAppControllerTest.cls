@isTest
private class WaveLabsAppControllerTest {
    static testMethod void testWaveLabsAppController() {
        WaveLabsAppController wc = new WaveLabsAppController();
        WaveLabsAppController.createRemoteSiteSettings('gs0');
    }
}