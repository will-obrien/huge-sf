/*
    Classe de testes: Validar_CPF_CNPJ_Teste
*/

public class Validar_CPF_CNPJ{

    public static boolean validarCPF(String cpfP){
        if(String.isEmpty(cpfP)) return false;

        cpfP = cpfP.replace('.', '').replace('-', '');
        
        if(Decimal.valueOf(cpfP) == 0) return false;
        
        String cpf = cpfP;
        
        if(cpfP.length() != 11) return false;
            
        cpf = cpf.substring(0, 9);
        String validacao = '98765432';
        Integer digitoVerificador = 0;
        Integer resultado = 0;

        //primeiro digito verificador
        resultado += Integer.valueOf(String.valueOf(cpf.substring(0, 1))) * 10;

        for(Integer a = 1; a < cpf.length(); a ++){
            String num1 = String.valueOf(cpf.substring(a, a + 1));
            String num2 = String.valueOf(validacao.substring(a - 1, a));
            resultado += Integer.valueOf(num1) * Integer.valueOf(num2);
        }

        digitoVerificador = (Math.mod(resultado, 11) < 2 ? 0 : 11 - (Math.mod(resultado, 11)));

        cpf += digitoVerificador;
        resultado = 0;

        //segundo digito verificador
        resultado += Integer.valueOf(String.valueOf(cpf.substring(0, 1))) * 11;
        resultado += Integer.valueOf(String.valueOf(cpf.substring(1, 2))) * 10;

        for(Integer a = 2; a < cpf.length(); a ++){
            String num1 = String.valueOf(cpf.substring(a, a + 1));
            String num2 = String.valueOf(validacao.substring(a - 2, a - 1));
            resultado += Integer.valueOf(num1) * Integer.valueOf(num2);
        }

        digitoVerificador = (Math.mod(resultado, 11) < 2 ? 0 : 11 - (Math.mod(resultado, 11)));

        cpf += digitoVerificador;

        return cpfP == cpf;
    }
    
    public static boolean validarCNPJ(String cnpjP){
        if(String.isEmpty(cnpjP)) return false;

        cnpjP = cnpjP.replace('.' , '').replace('/', '').replace('-', '');
        
        if(Decimal.valueOf(cnpjP) == 0) return false;
        
        String cnpj = cnpjP;
        
        if(cnpjP.length() != 14) return false;
        
        String calculoVerificador1 = '543298765432';
        String calculoVerificador2 = '6543298765432';
        Integer digitoVerificador = 0;
        Integer resultado = 0;
        
        cnpj = cnpj.substring(0, 12);
        
        //primeiro digito verificador
        for(Integer a = 0; a < cnpj.length(); a ++){
            String num1 = String.valueOf(cnpj.substring(a, a + 1));
            String num2 = String.valueOf(calculoVerificador1.substring(a, a + 1));
            Integer num3 = Integer.valueOf(num1) * Integer.valueOf(num2);
            resultado += num3;
        }
        
        digitoVerificador = (Math.mod(resultado, 11) < 2 ? 0 : 11 - Math.mod(resultado, 11));

        cnpj += digitoVerificador;        
        resultado = 0;
        
        //segundo digito verificador
        for(Integer a = 0; a < cnpj.length(); a ++){
            String num1 = String.valueOf(cnpj.substring(a, a + 1));
            String num2 = String.valueOf(calculoVerificador2.substring(a, a + 1));
            Integer num3 = Integer.valueOf(num1) * Integer.valueOf(num2);
            resultado += num3;
        }
        
        digitoVerificador = (Math.mod(resultado, 11) < 2 ? 0 : 11 - Math.mod(resultado, 11));
        
        cnpj += digitoVerificador;
        
        return cnpjP == cnpj;
    }

}