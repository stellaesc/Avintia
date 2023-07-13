public class ControllerFichaCliente {

    private final Lead ld;
    public Lead candidato {get; set;}
	public Promocion__c promocion {get; set;}
    public boolean undormitorio {get; set;}
    public boolean dosdormitorios  {get; set;}
    public boolean tresdormitorios  {get; set;}
    public boolean cuatrodormitorios  {get; set;}
    public boolean baja  {get; set;} 
    public boolean plantasIntermedias  {get; set;}
    public boolean atico  {get; set;}
    //public boolean otros  {get; set;}
    public boolean primeraResidenciaPrimerAcceso  {get; set;}
    public boolean primeraResidenciaReposicion  {get; set;}
    public boolean primeraResidenciaInversion  {get; set;}
    public boolean segundaResidenciaUsoPropio  {get; set;}
    public boolean segundaResidenciaInversion  {get; set;}
    public boolean residencial  {get; set;}
    public boolean vacacional  {get; set;}
    public boolean inversion  {get; set;}

    public ControllerFichaCliente(ApexPages.StandardController stdController){
        this.ld=(Lead)stdController.getRecord();
		//Id idLead = ApexPages.currentPage().getParameters().get('id');
		//Obtiene los datos del candidato
		candidato = [SELECT FirstName,LastName,MobilePhone,Email,Localidad__r.Name,Codigo_postal__c,LeadSource,Preferencia_Dormitorios__c,Uso_de_Inmueble__c,Necesita_Financiacion__c,Altura_de_vivienda_interes__c,Promocion__c FROM Lead WHERE id=:ld.Id];
		System.debug(candidato);
        undormitorio=false;
        dosdormitorios=false;
        tresdormitorios=false;
        cuatrodormitorios=false;
        if(candidato.Preferencia_Dormitorios__c!=null){
        IF(candidato.Preferencia_Dormitorios__c.contains('1'))undormitorio=true;
        IF(candidato.Preferencia_Dormitorios__c.contains('2'))dosdormitorios=true;
        IF(candidato.Preferencia_Dormitorios__c.contains('3'))tresdormitorios=true;
        IF(candidato.Preferencia_Dormitorios__c.contains('4'))cuatrodormitorios=true;
        }
        
       
        baja=false;
        plantasIntermedias=false;
        atico=false;
        //otros=false;
        if(candidato.Altura_de_vivienda_interes__c!=null){
        IF(candidato.Altura_de_vivienda_interes__c.contains('Bajo'))baja=true;
        IF(candidato.Altura_de_vivienda_interes__c.contains('Plantas intermedias'))plantasIntermedias=true;
        IF(candidato.Altura_de_vivienda_interes__c.contains('Ático'))atico=true;
        //IF(candidato.Altura_de_vivienda_interes__c.contains('2')||candidato.Altura_de_vivienda_interes__c.contains('3')||candidato.Altura_de_vivienda_interes__c.contains('+3'))otros=true;
        }
        
        
        residencial=false;
        vacacional=false;
        inversion=false;
        if(candidato.Uso_de_Inmueble__c!=null){
        IF(candidato.Uso_de_Inmueble__c.contains('1ª Residencia (Primer acceso)'))primeraResidenciaPrimerAcceso=true;
        IF(candidato.Uso_de_Inmueble__c.contains('1ª Residencia (Reposición)'))primeraResidenciaReposicion=true;
        IF(candidato.Uso_de_Inmueble__c.contains('1ª Residencia (Inversión)'))primeraResidenciaInversion=true;
        IF(candidato.Uso_de_Inmueble__c.contains('2ª Residencia (Uso propio)'))segundaResidenciaUsoPropio=true;
        IF(candidato.Uso_de_Inmueble__c.contains('2ª Residencia (Inversión)'))segundaResidenciaInversion=true;
        }
        
		if(candidato.Promocion__c !=null){
			//Obtiene los datos de la promoción
			promocion = [SELECT Socio_Empresa_Promotora__r.Name, Socio_Empresa_Promotora__r.DP_Tipo_de_vIa__c, Socio_Empresa_Promotora__r.DP_Nombre_via__c, Socio_Empresa_Promotora__r.DP_N_via__c, Socio_Empresa_Promotora__r.DP_Localidad__r.Name, Socio_Empresa_Promotora__r.DP_Provincia__c, Socio_Empresa_Promotora__r.DP_Codigo_postal__c FROM Promocion__c WHERE id=:candidato.Promocion__c];
			System.debug(promocion);
		}
    }
}