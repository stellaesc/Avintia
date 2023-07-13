public class ValidadorUtil {


    public static boolean esCuentaBancaria (String cuentaBancaria){
        
    //Validación de DC de la  cuenta bancaria
    Boolean cuentaValida=true;
    //cuentaBancaria=cuentaBancaria.replace(' ' ,'');
    //cuentaBancaria=cuentaBancaria.replace('-' ,'');
    //
    //Verificamos que la longitud sea 24
    if(cuentaBancaria.length()>=24)
    {
        String cuenta=(cuentaBancaria.substring(4,24));
        String IBAN=(cuentaBancaria.substring(0,4));
        system.debug('Cuenta del Banco ' +cuenta);
    
        Pattern cuentaPattern = Pattern.compile('\\d{20}');
        Matcher m = cuentaPattern.matcher(cuenta);
        if(m.matches()){
            system.debug('cuenta cumple el patrón (20 dígitos)');
    
            String banco = cuenta.substring(0,8);
            system.debug('Banco (con 00) '+banco);
    
            Integer suma = //Integer.valueof(banco.substring(0,1))*1+
                //Integer.valueof(banco.substring(1,2))*2+
                Integer.valueof(banco.substring(0,1))*4+
                Integer.valueof(banco.substring(1,2))*8+
                Integer.valueof(banco.substring(2,3))*5+
                Integer.valueof(banco.substring(3,4))*10+
                Integer.valueof(banco.substring(4,5))*9+
                Integer.valueof(banco.substring(5,6))*7+
                Integer.valueof(banco.substring(6,7))*3+
                Integer.valueof(banco.substring(7,8))*6;
    
            Integer control= 11 - (math.mod(suma,11));
            system.debug('control banco después del modulo 11 '+control);
            if (control==10)
                control=1;
            else if (control==11)
                control=0;
    
            system.debug('control '+control );
    
            Integer controlBanco = Integer.valueof(cuenta.substring(8,9));
            if (controlBanco!=control)
                cuentaValida=false;
            else
            {
                system.debug('El control del banco está bien');
            }
            

            if(cuentaValida)
            {
                system.debug('cuenta '+cuenta.substring(10,20));
    
                suma = Integer.valueof(cuenta.substring(10,11))*1+
                    Integer.valueof(cuenta.substring(11,12))*2+
                    Integer.valueof(cuenta.substring(12,13))*4+
                    Integer.valueof(cuenta.substring(13,14))*8+
                    Integer.valueof(cuenta.substring(14,15))*5+
                    Integer.valueof(cuenta.substring(15,16))*10+
                    Integer.valueof(cuenta.substring(16,17))*9+
                    Integer.valueof(cuenta.substring(17,18))*7+
                    Integer.valueof(cuenta.substring(18,19))*3+
                    Integer.valueof(cuenta.substring(19,20))*6;
    
                control= 11 - (math.mod(suma,11));
                system.debug('control cuenta después del modulo 11 '+control);
                if (control==10)
                    control=1;
                else if (control==11)
                    control=0;
        
                system.debug('control '+control);
                Integer controlcuenta = Integer.valueof(cuenta.substring(9,10));
                if (controlcuenta!=control)
                    cuentaValida=false;
            }	
    
        }
        else
            cuentaValida= false;
        //Validamos el IBAN de la cuenta bancaria    
        if(cuentaValida)
        { 
            string primerCarcter=IBAN.substring(0,1);
            string segundoCaracter=IBAN.substring(1,2);
            string digitoControlIban=IBAN.substring(2,4);
            system.debug(primerCarcter);
            system.debug(segundoCaracter);

            if(primerCarcter.equals('E'))
            {
                primerCarcter='14';

                if(segundoCaracter.equals('S'))
                {
                    segundoCaracter='28';
                    system.debug(cuenta);
                    
                    String cuentaIban=cuenta+primerCarcter+segundoCaracter+'00';
                    // Troceamos el ccc en partes (26 digitos) para hacer módulo 97
                    string[] partesCCC = new string[5];
                    partesCCC[0] = cuentaIban.Substring(0, 5);
                    partesCCC[1] = cuentaIban.Substring(5, 10);
                    partesCCC[2] = cuentaIban.Substring(10, 15);
                    partesCCC[3] = cuentaIban.Substring(15, 20);
                    partesCCC[4] = cuentaIban.Substring(20, 26);
                    
                    integer iResultado = math.mod(integer.valueof(partesCCC[0]), 97);
                    string sResultado = String.valueOf(iResultado);
                    for (integer i = 0; i < partesCCC.size() - 1; i++)
                    {
                        iResultado = math.mod(integer.valueof(sResultado + partesCCC[i + 1]),97);
                        sResultado = String.valueof(iResultado);
                    }
                    // Le restamos el resultado a 98
                    integer controlIBAN = 98 - integer.valueof(sResultado);
                    string restoIban = String.valueof(controlIBAN);
                    if (restoIban.length() == 1)
                        restoIban = '0' + restoIban;
                

                    system.debug ('Control iban es: '+ restoIban);
                    if(!restoIban.equals(digitoControlIban))
                        cuentaValida=false;

                }
                else
                {
                    cuentaValida=false;
                }

            }
            else
            {
                cuentaValida=false;
            }


        }
    }
    else
    {
        cuentaValida=false;
    }

 return cuentaValida;
}
}