/*
    Classe de testes: Pagina_Util_Teste
*/

public class Pagina_Util{

    public static void showError(Object o){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
            formatarErro(o)));
    }
    
    public static void showConfirm(Object o){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
            String.valueOf(o)));
    }
    
    private static String formatarErro(Object o){
        String s = String.valueOf(o);
        
        if(s.contains('_EXCEPTION')) return s.substring(s.indexOf('_EXCEPTION, ') + 12, s.length() - 4);
        else return s;
    }

}