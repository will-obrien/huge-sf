Global class remoteControllerDemo{
    Public String AccName{get;set;}
    Public static  account acc{get;set;}
    Public remoteControllerDemo(){
    }
    @RemoteAction
    Global Static Account getAccount(String AccName){
        acc = [ select id,name from Account where name=: AccName];
        return acc;
    }
}