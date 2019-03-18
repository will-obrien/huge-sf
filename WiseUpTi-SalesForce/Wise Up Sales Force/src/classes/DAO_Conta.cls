/*
    Classe de testes: DAO_Conta_Teste
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

public class DAO_Conta{

     public static Map<String, String> recuperaEmail(List<String> email){
     
         Map<String, String> listaContas = new Map<String, String>();
                         
         for (Account a : [SELECT Id, PersonEmail FROM Account WHERE PersonEmail IN : email]){
             listaContas.put(a.PersonEmail, a.Id);
         }
         
         return listaContas; 
     }
     
}