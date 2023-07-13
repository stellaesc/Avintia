public class IBANValidation {
    
    private static String rearrange(String iban) {
        iban = iban.trim().toUpperCase();
        iban = iban.replaceAll('(\\s+)', '');
        String start = iban.substring(0,4);
        String ending = iban.substring(4);
        String rearranged = ending + start;
        
        System.debug('####rearranged : ' + rearranged);
        return rearranged;
    }
    
    private static String convertToInteger(String iban) {
        iban = iban.replaceAll('A', '10');
        iban = iban.replaceAll('B', '11');
        iban = iban.replaceAll('C', '12');
        iban = iban.replaceAll('D', '13');
        iban = iban.replaceAll('E', '14');
        iban = iban.replaceAll('F', '15');
        iban = iban.replaceAll('G', '16');
        iban = iban.replaceAll('H', '17');
        iban = iban.replaceAll('I', '18');
        iban = iban.replaceAll('J', '19');
        iban = iban.replaceAll('K', '20');
        iban = iban.replaceAll('L', '21');
        iban = iban.replaceAll('M', '22');
        iban = iban.replaceAll('N', '23');
        iban = iban.replaceAll('O', '24');
        iban = iban.replaceAll('P', '25');
        iban = iban.replaceAll('Q', '26');
        iban = iban.replaceAll('R', '27');
        iban = iban.replaceAll('S', '28');
        iban = iban.replaceAll('T', '29');
        iban = iban.replaceAll('U', '30');
        iban = iban.replaceAll('V', '31');
        iban = iban.replaceAll('W', '32');
        iban = iban.replaceAll('X', '33');
        iban = iban.replaceAll('Y', '34');
        iban = iban.replaceAll('Z', '35');

        return iban;
    }
    
    private static Long performModulos(String iban) {
        
        //Doing a mod 97 on the first 9-digits chunk
		String part1 = iban.substring(0,9);
        System.debug('####part1 : ' + part1);
        Long result1 = Math.mod(Long.valueOf(part1) , Long.valueOf('97') );
       
        Integer currentPosition = 9;
        Boolean digitsRemaining = true;
        Long result = result1;
        String partN;
        
        //Doing a mod 97 on the next 7-digits chunk
        //Or the last chunk if there is less than 7 digits remaining
        while (digitsRemaining) {
            
            if (iban.length() < (currentPosition+7) ) {
                digitsRemaining = false;
            }
            
            if (digitsRemaining) {
                partN = String.valueOf(result) + iban.substring(currentPosition,currentPosition+7);
        		System.debug('####part ' + currentPosition + ' to ' + currentPosition+7);
        		result = Math.mod(Long.valueOf(partN) , Long.valueOf('97') );
            } else {
                partN = String.valueOf(result) + iban.substring(currentPosition);
        		System.debug('####part ' + currentPosition + ' to end');
        		result = Math.mod(Long.valueOf(partN) , Long.valueOf('97') );
            }
            
            currentPosition+=7;
        }
       
        return result;
    }
    
    public static boolean validateIban(String iban) {
        //iban  = 'GB82 WEST 1234 5698 7654 32';
        //iban  = 'DE89 3704 0044 0532 0130 00';
        //iban  = 'FR14 2004 1010 0505 0001 3M02 606';
        //iban  = 'FR7610807004090232158413487';
        //iban  = 'FR7616707000190112158931852';
        
        //Step #1 : rearranging the IBAN string by moving the first four digits to the end
        iban = rearrange(iban);
        //Step #2 : converting the letters to their corresponding numbers
        iban = convertToInteger(iban);
		//Step #3 : Performs modulos by doing a sequence of modulos 97 on the formatted IBAN string
        Long result = performModulos(iban);
		
        //If the result is 1, then the IBAN is valid
        return result == 1;
    }

}