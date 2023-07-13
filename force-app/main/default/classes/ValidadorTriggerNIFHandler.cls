public class ValidadorTriggerNIFHandler {
    // Method Name: validateNIFEmpresa                       *
    // Description: Valida el NIF de una empresa española    *
    // param: String numDoc: document number to be validated *
    // Author: Deloitte										 *

    public static boolean validateNIFEmpresa(String numDoc) {
        system.debug('validateNIFEmpresa');
        boolean error = false;
        if (numDoc != null && numDoc != '') {

            if (numDoc.length() == 9) {
                //obtenemos el tipo de organizacion
                String tipoOrganizacion = numDoc.substring(0, 1);

                //obtenemos el codigo de provincia
                String codProvincia = numDoc.substring(1, 3);

                //obtenemos el correlativo
                String correlativo = numDoc.substring(3, 8);

                //obtenemos el digito de control
                String control = numDoc.substring(8, 9);

                if (!tipoOrganizacion.isAlpha()
                        || !codProvincia.isNumeric()
                        || !correlativo.isNumeric()
                        || (!tipoOrganizacion.containsOnly('ABCDEFGHJNPQRSUVW'))
                        || (tipoOrganizacion.containsOnly('PQSW') && !control.isAlpha())
                        || (tipoOrganizacion.containsOnly('ABEH') && !control.isNumeric())) {

                    error = true;
                }
            } else {
                error = true;
            }
        } else {
            error = true;
        }

        return error;
    }

    //
    // Method Name: validateNIFpersona                       *
    // Description: Valida el NIF de una empresa española    *
    // param: String numDoc: document number to be validated *
    // Author: Deloitte										 *


    public static boolean validateNIFpersona(String numdoc) {

        Map<Integer, String> letraNIFMap = new Map<Integer, String>();
        letraNIFMap.put(1, 'T');
        letraNIFMap.put(2, 'R');
        letraNIFMap.put(3, 'W');
        letraNIFMap.put(4, 'A');
        letraNIFMap.put(5, 'G');
        letraNIFMap.put(6, 'M');
        letraNIFMap.put(7, 'Y');
        letraNIFMap.put(8, 'F');
        letraNIFMap.put(9, 'P');
        letraNIFMap.put(10, 'D');
        letraNIFMap.put(11, 'X');
        letraNIFMap.put(12, 'B');
        letraNIFMap.put(13, 'N');
        letraNIFMap.put(14, 'J');
        letraNIFMap.put(15, 'Z');
        letraNIFMap.put(16, 'S');
        letraNIFMap.put(17, 'Q');
        letraNIFMap.put(18, 'V');
        letraNIFMap.put(19, 'H');
        letraNIFMap.put(20, 'L');
        letraNIFMap.put(21, 'C');
        letraNIFMap.put(22, 'K');
        letraNIFMap.put(23, 'E');

        if (numdoc != null && numdoc != '') {

            //crear pattern
            Pattern myPattern = pattern.compile('[0-9]{8}[a-zA-Z]');
            Matcher myMatcher = myPattern.matcher(numdoc);

            if (myMatcher.matches()) {

                //calculo parte numerica
                Integer parteNumerica = Math.mod(Integer.valueOf(numdoc.substring(0, 8)), 23) + 1;

                if (letraNIFMap.containsKey(parteNumerica) && letraNIFMap.get(parteNumerica) == numdoc.substring(8, 9).toUpperCase()) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    }


    // Method Name: validateNIE                       *
    // Description: Valida el NIE    *
    // param: String numDoc: document number to be validated *
    // Author: Deloitte										 *


    public static boolean validateNIE(String nie) {

        boolean esValido = false;
        integer i = 1;
        integer caracterASCII = 0;
        String letra = ' ';
        integer miNIE = 0;
        integer resto = 0;
        String[] asignacionLetra = new String[]{
                'T', 'R', 'W', 'A', 'G', 'M', 'Y', 'F', 'P', 'D', 'X', 'B', 'N', 'J', 'Z', 'S', 'Q', 'V', 'H', 'L', 'C', 'K', 'E'
        };


        if (nie.length() == 9 && nie.substring(8, 9).toUpperCase().isAlpha()
                && (nie.substring(0, 1).toUpperCase().equals('X')
                || nie.substring(0, 1).toUpperCase().equals('Y')
                || nie.substring(0, 1).toUpperCase().equals('Z'))) {

            do {
                caracterASCII = nie.codePointAt(i);
                esValido = (caracterASCII > 47 && caracterASCII < 58);
                i++;
            } while (i < nie.length() - 1 && esValido);
        }

        if (esValido && nie.substring(0, 1).toUpperCase().equals('X')) {
            nie = '0' + nie.substring(1, 9);
        } else if (esValido && nie.substring(0, 1).toUpperCase().equals('Y')) {
            nie = '1' + nie.substring(1, 9);
        } else if (esValido && nie.substring(0, 1).toUpperCase().equals('Z')) {
            nie = '2' + nie.substring(1, 9);
        }

        if (esValido) {
            letra = nie.substring(8, 9).toUpperCase();
            miNIE = Integer.valueOf(nie.substring(0, 8));
            resto = math.mod(miNIE, 23);
            esValido = (letra == asignacionLetra[resto]);
        }

        return esValido;
    }
}