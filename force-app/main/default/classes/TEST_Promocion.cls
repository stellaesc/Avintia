/**
 * Clase test de la clase HL_Promocion
 *
 * Historial
 * ------------------------------------------------------------------------------------------------------
 *
 *	v1.0		
 */
@isTest
private class TEST_Promocion {
    
    
    @isTest
    static void testCrearRitmoDeVentas(){
        
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09,20 );
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10,03 );
        
        Integer NumSemanas = (fechaInicioComercializacionPrevista.toStartOfWeek().daysBetween(fechaFinComercializacionPrevista.toStartOfWeek()))/7;
        
        promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista );
 		
        Map<id,Ritmo_ventas__c> mapRitmoVentas = TestUtil.getRitmoVentas(promocion.id);
        
        
        Integer NumRegistrosRitmosVentas = mapRitmoVentas.size();
        
       
        //Comprueba que se crea un registro por semana (Se añade 1 a NumSemanas porque en el bucle de creación se tiene en cuenta)
        System.assertEquals(NumSemanas+1, NumRegistrosRitmosVentas);
        
    
        
        //Se comprueba que la fecha de inicio del primer ritmo de ventas coincide con la fecha de inicio de comercialización prevista
        date fechaInicialPrimerRitmoDeVentas = fechaInicioComercializacionPrevista;
       
        for(id rit : mapRitmoVentas.keyset()){
            
            if(mapRitmoVentas.get(rit).Fecha_inicio_periodo__c < fechaInicialPrimerRitmoDeVentas){
                
               fechaInicialPrimerRitmoDeVentas  = mapRitmoVentas.get(rit).Fecha_inicio_periodo__c;
            }
        }

        system.assertEquals(fechaInicioComercializacionPrevista, fechaInicialPrimerRitmoDeVentas);
        
        
        
        //Se comprueba que la fecha de fin del ultimo ritmo de ventas coincide con la fecha de fin de comercialización prevista
        date fechaFinUltimoRitmoDeVentas = fechaFinComercializacionPrevista;
       
        for(id rit : mapRitmoVentas.keyset()){
            
            if(mapRitmoVentas.get(rit).Fecha_fin_periodo__c > fechaFinUltimoRitmoDeVentas){
                
               fechaFinUltimoRitmoDeVentas  = mapRitmoVentas.get(rit).Fecha_fin_periodo__c;
            }
        }
        
        system.assertEquals(fechaFinComercializacionPrevista, fechaFinUltimoRitmoDeVentas);
        

    }

     @isTest
    static void testAdelantarInicioComercializacionPrevista(){
        
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09,20 );
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10,03 );
        
        date fechaInicioComercializacionPrevistaNew = date.newInstance(2018, 08,20 );
        

        promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        promocion.Inicio_comercializacion_prevista__c = fechaInicioComercializacionPrevistaNew;
        
        update promocion;
        
        Map<id,Ritmo_ventas__c> mapRitmoVentas = TestUtil.getRitmoVentas(promocion.id);
        
        Integer NumSemanas = (fechaInicioComercializacionPrevistaNew.toStartOfWeek().daysBetween(fechaFinComercializacionPrevista.toStartOfWeek()))/7;
        Integer NumRegistrosRitmosVentas = mapRitmoVentas.size();
        
        
       
        //Comprueba que hay un registro por semana (Se añade 1 a NumSemanas porque en el bucle de creación se tiene en cuenta)
        System.assertEquals(NumSemanas+1, NumRegistrosRitmosVentas);
        
 
        //Se comprueba que la fecha de inicio del primer ritmo de ventas coincide con la fecha de inicio de comercialización prevista
        date fechaInicialPrimerRitmoDeVentas = fechaInicioComercializacionPrevistaNew;
       
        for(id rit : mapRitmoVentas.keyset()){
            
            if(mapRitmoVentas.get(rit).Fecha_inicio_periodo__c < fechaInicialPrimerRitmoDeVentas){
                
               fechaInicialPrimerRitmoDeVentas  = mapRitmoVentas.get(rit).Fecha_inicio_periodo__c;
            }
        }
        
        system.assertEquals(fechaInicioComercializacionPrevistaNew, fechaInicialPrimerRitmoDeVentas);

    }
    
    @isTest
    static void testRetrasarInicioComercializacionPrevista(){
        
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09,20);
        date fechaFinComercializacionPrevista = date.newInstance(2022, 10,03);
        
        date fechaInicioComercializacionPrevistaNew = date.newInstance(2019, 09,20 );
        

        promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        promocion.Inicio_comercializacion_prevista__c = fechaInicioComercializacionPrevistaNew;
        
        update promocion;
        
        Map<id,Ritmo_ventas__c> mapRitmoVentas = TestUtil.getRitmoVentas(promocion.id);
        
        Integer NumSemanas = (fechaInicioComercializacionPrevistaNew.toStartOfWeek().daysBetween(fechaFinComercializacionPrevista.toStartOfWeek()))/7;
        Integer NumRegistrosRitmosVentas = mapRitmoVentas.size();
        
        
       
        //Comprueba que hay un registro por semana (Se añade 1 a NumSemanas porque en el bucle de creación se tiene en cuenta)
        System.assertEquals(NumSemanas+1, NumRegistrosRitmosVentas);
        
 
        //Se comprueba que la fecha de inicio del primer ritmo de ventas coincide con la fecha de inicio de comercialización prevista
        date fechaInicialPrimerRitmoDeVentas = fechaInicioComercializacionPrevistaNew;
       
        for(id rit : mapRitmoVentas.keyset()){
            
            if(mapRitmoVentas.get(rit).Fecha_inicio_periodo__c < fechaInicialPrimerRitmoDeVentas){
                
               fechaInicialPrimerRitmoDeVentas  = mapRitmoVentas.get(rit).Fecha_inicio_periodo__c;
            }
        }

        system.assertEquals(fechaInicioComercializacionPrevistaNew, fechaInicialPrimerRitmoDeVentas);

    }
    
    @isTest
    static void testRetrasarFinComercializacionPrevista(){
        
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09,20 );
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10,03 );
        
        date fechaFinComercializacionPrevistaNew = date.newInstance(2020, 08,20 );
        

        promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        promocion.Fin_comercializacion_prevista__c = fechaFinComercializacionPrevistaNew;
        
        update promocion;
        
        Map<id,Ritmo_ventas__c> mapRitmoVentas = TestUtil.getRitmoVentas(promocion.id);
        
        Integer NumSemanas = (fechaInicioComercializacionPrevista.toStartOfWeek().daysBetween(fechaFinComercializacionPrevistaNew.toStartOfWeek()))/7;
        Integer NumRegistrosRitmosVentas = mapRitmoVentas.size();
        
        
       
        //Comprueba que hay un registro por semana (Se añade 1 a NumSemanas porque en el bucle de creación se tiene en cuenta)
        System.assertEquals(NumSemanas+1, NumRegistrosRitmosVentas);
        
 
        //Se comprueba que la fecha fin del ultimo ritmo de ventas coincide con la fecha de fin de comercialización prevista
        date fechaFinalPrimerRitmoDeVentas = fechaFinComercializacionPrevistaNew;
       
        for(id rit : mapRitmoVentas.keyset()){
            
            if(mapRitmoVentas.get(rit).Fecha_fin_periodo__c > fechaFinalPrimerRitmoDeVentas){
                
               fechaFinalPrimerRitmoDeVentas  = mapRitmoVentas.get(rit).Fecha_fin_periodo__c;
            }
        }

        system.assertEquals(fechaFinComercializacionPrevistaNew, fechaFinalPrimerRitmoDeVentas);

    }
    
    @isTest
    static void testAdelantarFinComercializacionPrevista(){
        
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 10,03 );
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10,04 );
        
        date fechaFinComercializacionPrevistaNew = date.newInstance(2020, 18,10 );
        

        promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        promocion.Fin_comercializacion_prevista__c = fechaFinComercializacionPrevistaNew;
        
        update promocion;
        
        Map<id,Ritmo_ventas__c> mapRitmoVentas = TestUtil.getRitmoVentas(promocion.id);
        
        Integer NumSemanas = (fechaInicioComercializacionPrevista.toStartOfWeek().daysBetween(fechaFinComercializacionPrevistaNew.toStartOfWeek()))/7;
        Integer NumRegistrosRitmosVentas = mapRitmoVentas.size();
        

        //Comprueba que hay un registro por semana (Se añade 1 a NumSemanas porque en el bucle de creación se tiene en cuenta)
        System.assertEquals(NumSemanas+1, NumRegistrosRitmosVentas);
        
 
        
        //Se comprueba que la fecha fin del ultimo ritmo de ventas coincide con la fecha de fin de comercialización prevista
        date fechaFinalPrimerRitmoDeVentas = fechaFinComercializacionPrevistaNew;
       
        for(id rit : mapRitmoVentas.keyset()){
            
            if(mapRitmoVentas.get(rit).Fecha_fin_periodo__c > fechaFinalPrimerRitmoDeVentas){
                
               fechaFinalPrimerRitmoDeVentas  = mapRitmoVentas.get(rit).Fecha_fin_periodo__c;
            }
        }

        system.assertEquals(fechaFinComercializacionPrevistaNew, fechaFinalPrimerRitmoDeVentas);

    }
        
}