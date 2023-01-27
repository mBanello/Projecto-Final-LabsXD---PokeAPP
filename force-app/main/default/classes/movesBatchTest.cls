@istest
public with sharing class movesBatchTest {
	
	@isTest
	static void shouldInsertMoveWithAllTheData(){
		SingleRequestMock mock = new SingleRequestMock(
			200,
			'OK',
			'{"accuracy": 100,"effect_chance": 85,"effect_entries": [{"language": {"name": "en"},"short_effect": "Random effect"}],"id": 1,"name": "pound","power": 40,"pp": 35,"priority": 0,"target": {"name": "selected-pokemon"},"type": {"name": "normal"}}',
            null
            );
		Test.setMock(HttpCalloutMock.Class, mock);
		Test.StartTest();
            movesBatch moves = new movesBatch();
		    database.executeBatch(moves);
		Test.stopTest();
        Movimiento__c movAVerificar = [SELECT Id,
                                              Name,
                                              Movimiento__c.ExtId__c,
                                              Movimiento__c.Chance_de_Efecto__c,
                                              Movimiento__c.Punteria__c,
                                              Movimiento__c.Objetivo__c,
                                              Movimiento__c.Prioridad__c,
                                              Movimiento__c.Efecto__c,
                                              Movimiento__c.Poder__c,
                                              Movimiento__c.Pp__c,
                                              Movimiento__c.Tipo__c 
                                       FROM Movimiento__c 
                                       LIMIT 1];
		system.assertEquals(1, movAVerificar.ExtId__c, 'El campo ExtId no conicide');
        system.assertEquals('Pound', movAVerificar.name);
        system.assertEquals(100, movAVerificar.Punteria__c);
        system.assertEquals('Selected-pokemon', movAVerificar.Objetivo__c);
        system.assertEquals(0, movAVerificar.Prioridad__c);
        system.assertEquals('Random effect', movAVerificar.Efecto__c);
        system.assertEquals(40, movAVerificar.Poder__c);
        system.assertEquals(35, movAVerificar.Pp__c);
        system.assertEquals('Normal', movAVerificar.Tipo__c);
        system.assertEquals('85%',movAVerificar.Chance_de_Efecto__c);
	}

	@isTest
    static void shouldInsertMoveWithEmptyFieldsWhenNoDataOrNull(){
		SingleRequestMock mock = new SingleRequestMock(
			200,
			'OK',
			'{"accuracy": 100,"effect_chance": 85,"effect_entries": [{"language": {"name": "en"},"short_effect": "Random effect"}],"id": 1,"name": "pound","power": 40,"pp": 35,"priority": 0,"target": {"name": "null"},"type": {"name": "normal"}}',
			null
			);
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
			database.executeBatch(new movesBatch());
		Test.stopTest();
		Movimiento__c movAVerificar = [SELECT Id,
                                            Name,
                                            Movimiento__c.ExtId__c,
                                            Movimiento__c.Punteria__c,
                                            Movimiento__c.Objetivo__c,
                                            Movimiento__c.Prioridad__c,
                                            Movimiento__c.Efecto__c,
                                            Movimiento__c.Poder__c,
                                            Movimiento__c.Pp__c,
                                            Movimiento__c.Tipo__c 
                                        FROM  Movimiento__c Limit 1];
        System.assertEquals('Sin Objetivo', movAVerificar.Objetivo__c);
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
            	database.executeBatch(new abilitiesBatch());
        	} catch (Exception e){
            	error = e.getMessage();
            }
		Test.stopTest();
        
		system.assertEquals('Error: ' + responseExpected, error , 'El error no fue el esperado, fue :' + error);
    }
}