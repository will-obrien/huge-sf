public abstract class SynchronizeManager {
    
    public class MockException extends Exception{}
    
    protected SynchronizeManager() {
        
    }
    
    public SynchronizeResult synchronize() {
        SyncLogger logger = new SyncLogger ('SynchronizeManager');
        SynchronizeResult result = new SynchronizeResult();
        try{
            this.implement(logger,result);
        }catch(Exception ex) {
            system.debug(ex.getStackTraceString());
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
        }
        logger.emailDebugResults('webdev@markettraders.com',true);
        return result;
    }
    
    protected abstract void implement(SyncLogger logger,SynchronizeResult result);
    
    public static SynchronizeManager getMockSynchronizeManager(boolean throwError) {
        return new MockSynchronizeManager(throwError);
    }
    
    private Class MockSynchronizeManager extends SynchronizeManager {
        
        private boolean throwError;
        
        private MockSynchronizeManager(boolean throwError) {
            this.throwError = throwError;
        }
        
        protected override void implement(SyncLogger logger,SynchronizeResult result) {
            if(this.throwError == true)
                throw new MockException('A mock exception was thrown.');
        }
        
    }

}