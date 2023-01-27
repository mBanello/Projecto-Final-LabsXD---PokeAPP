@istest
public with sharing class abilitiestBatchTest {
	
	@isTest
	static void shouldInsertAbilityWithAllTheData(){
		SingleRequestMock mock = new SingleRequestMock(
			200,
			'OK',
			'{"effect_entries": [{"language": {"name": "en"},"short_effect": "Random eff for test"}],"id": 2,"name": "drizzle"})',
			null
			);
		Test.setMock(HttpCalloutMock.Class, mock);
		Test.StartTest();
        abilitiesBatch abilities = new abilitiesBatch();
		database.executeBatch(abilities);
		Test.stopTest();
		Habilidad__c habAVerificar = [Select Id,Name, Efecto__c,ExtId__c 
                                      FROM  Habilidad__c 
                                      Limit 1];

		system.assertEquals('Drizzle', habAVerificar.name, 'Los nombres de Habilidad no coinciden');
		system.assertEquals('Random eff for test', habAVerificar.Efecto__c, 'El campo Efect__c no coincide');
		system.assertEquals(2, habAVerificar.ExtId__c, 'El campo ExtId no conicide');
	}

	@isTest
	static void shouldInsertAbilityWithEmptyEffect(){
		SingleRequestMock mock = new SingleRequestMock(
			200,
			'OK',
			'{"effect_entries": [{"language": {"name": "en"},"short_effect":"null"}],"id": 2,"name": "drizzle"})',
			null
			);
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
			database.executeBatch(new abilitiesBatch());
		Test.stopTest();
		Habilidad__c habAVerificar = [SELECT Id,Name,Efecto__c FROM Habilidad__c Limit 1];
		system.assertEquals('Sin efecto', habAVerificar.Efecto__c, 'El efecto esperado era vacio y no fue asi');
	}
    //arreglar este que no funciona
    @isTest
    static void shouldThrowCalloutException(){
        String responseExpected = 'El servicio no está disponible';
        SingleRequestMock errorMock = new SingleRequestMock(
			500,
			'Error',
			responseExpected,
			null
		);
		Test.setMock(HttpCalloutMock.class, errorMock);
        String error = null;
		Test.startTest();
        	try{
            	Database.executeBatch(new abilitiesBatch(),1);
        	} catch(CalloutException e){
            	error = e.getMessage();
            }
		Test.stopTest();
        
		System.assertEquals('Error: ' + responseExpected, error , 'El error no fue el esperado, fue :' + error);
    }
}