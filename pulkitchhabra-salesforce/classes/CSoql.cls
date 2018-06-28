public class CSoql {
    public static void query(){
      Account[]temp=[Select name from account where name in ('GenePoint','sForce')];
            system.debug(temp);
    }

}