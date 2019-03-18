@isTest
private class WaveLabsControllerTest {
    static testMethod void testWaveLabsController() {
        WaveLabsController wc = new WaveLabsController();
        wc.getOrg();
        wc.getSid();
    }
}