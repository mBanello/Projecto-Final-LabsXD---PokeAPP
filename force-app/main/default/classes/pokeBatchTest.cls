@istest
public with sharing class pokeBatchTest {
    @TestSetup
    static void makeData(){
        Habilidad__c overgrow = new Habilidad__c();
        overgrow.Name = 'Overgrow';
        Habilidad__c chlorophyll = new Habilidad__c();
        chlorophyll.Name = 'Chlorophyll';
        
        insert chlorophyll;
        insert overgrow;
    }
	
	@isTest
	static void shouldInsertPokemonWithAllTheData(){
        Movimiento__c Mov1 = new Movimiento__c();
        Mov1.Name = 'Razor-wind';
        Movimiento__c Mov2 = new Movimiento__c();
        Mov2.Name = 'Swords-dance';
        Movimiento__c Mov3 = new Movimiento__c();
        Mov3.Name = 'Cut';
        Movimiento__c Mov4 = new Movimiento__c();
        Mov4.Name = 'Bind';
        insert Mov1;
        insert Mov2;
        insert Mov3;
        insert Mov4;
        String responseExpected = '{"abilities": [{"ability": {"name": "overgrow"}}],"height": 7,"id": 1,"moves": [{"move": {"name": "razor-wind"}},{"move": {"name": "swords-dance"}},{"move": {"name": "cut"}},{"move": {"name": "bind"}}],"name": "bulbasaur","sprites": {"front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"},"stats": [{"base_stat": 45,"stat": {"name": "hp"}},{"base_stat": 49,"stat": {"name": "attack"}},{"base_stat": 49,"stat": {"name": "defense"}},{"base_stat": 45,"stat": {"name": "speed"}}],"types": [{"type": {"name": "grass"}},{"type": {"name": "poison"}}],"weight": 69}';
		SingleRequestMock mock = new SingleRequestMock(
			200,
			'OK',
			responseExpected,
			null
			);
		Test.setMock(HttpCalloutMock.Class, mock);
		Test.StartTest();
        	pokeBatch pokemon = new pokeBatch();
			database.executeBatch(pokemon);
		Test.stopTest();
        Pokemon__c pokeAVerificar = [SELECT Name,
                                     Pokemon__c.ExtId__c,
                                     Pokemon__c.Habilidad__c,
                                     Pokemon__c.Altura__c,
                                     Pokemon__c.Peso__c,
                                     Pokemon__c.Imagen__c,
                                     Pokemon__c.Tipos__c,
                                     Pokemon__c.Vida__c,
                                     Pokemon__c.Velocidad__c,
                                     Pokemon__c.Defensa__c,
                                     Pokemon__c.Ataque__c,
                                     Pokemon__c.Slot1__c,
                                     Pokemon__c.Slot2__c,
                                     Pokemon__c.Slot3__c,
                                     Pokemon__c.Slot4__c
                                     FROM Pokemon__c LIMIT 1];
        
        system.assertEquals(1, pokeAVerificar.ExtId__c);
        system.assertEquals('70 cm.', pokeAVerificar.Altura__c);
        system.assertEquals('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png', pokeAVerificar.Imagen__c);
        system.assertEquals(45, pokeAVerificar.Vida__c);
        system.assertEquals(49, pokeAVerificar.Ataque__c);
        system.assertEquals(49, pokeAVerificar.Defensa__c);
        system.assertEquals(45, pokeAVerificar.Velocidad__c);
        system.assertEquals('69 kgs.', pokeAVerificar.Peso__c);

		
	}
    @isTest
	static void shouldInsertPokemonWithLessThan4MovesAndLessThan2Types(){
        Movimiento__c Mov1 = new Movimiento__c();
        Mov1.Name = 'Razor-wind';
        Movimiento__c Mov2 = new Movimiento__c();
        Mov2.Name = 'Swords-dance';
        Movimiento__c Mov3 = new Movimiento__c();
        Mov3.Name = 'Cut';
        insert Mov1;
        insert Mov2;
        insert Mov3;
        String responseExpected = '{"abilities": [{"ability": {"name": "overgrow"}}],"height": 7,"id": 1,"moves": [{"move": {"name": "razor-wind"}}],"name": "bulbasaur","sprites": {"front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"},"stats": [{"base_stat": 45,"stat": {"name": "hp"}},{"base_stat": 49,"stat": {"name": "attack"}},{"base_stat": 49,"stat": {"name": "defense"}},{"base_stat": 45,"stat": {"name": "speed"}}],"types": [{"type": {"name": "poison"}}],"weight": 69}';
		SingleRequestMock mock = new SingleRequestMock(
			200,
			'OK',
			responseExpected,
			null
			);
		Test.setMock(HttpCalloutMock.Class, mock);
		Test.StartTest();
        	pokeBatch pokemon = new pokeBatch();
			database.executeBatch(pokemon);
		Test.stopTest();
        Pokemon__c pokeAVerificar = [SELECT Name,
                                     Pokemon__c.ExtId__c,
                                     Pokemon__c.Habilidad__c,
                                     Pokemon__c.Altura__c,
                                     Pokemon__c.Peso__c,
                                     Pokemon__c.Imagen__c,
                                     Pokemon__c.Tipos__c,
                                     Pokemon__c.Vida__c,
                                     Pokemon__c.Velocidad__c,
                                     Pokemon__c.Defensa__c,
                                     Pokemon__c.Ataque__c,
                                     Pokemon__c.Slot1__c,
                                     Pokemon__c.Slot2__c,
                                     Pokemon__c.Slot3__c,
                                     Pokemon__c.Slot4__c
                                     FROM Pokemon__c LIMIT 1];
        
        String idMove = [Select Id from Movimiento__c where Name = 'Razor-wind'].id;
        system.assertEquals('Poison', pokeAVerificar.Tipos__c);
        system.assertEquals(idMove, pokeAVerificar.Slot1__c);
        system.assertEquals(null, pokeAVerificar.Slot2__c);
        system.assertEquals(null, pokeAVerificar.Slot3__c);
        system.assertEquals(null, pokeAVerificar.Slot4__c);
	}
    /*arreglar este que no funciona
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
        	} catch (DmlException e){
            	error = e.getMessage();
            }
		Test.stopTest();
        
		system.assertEquals('Error: ' + responseExpected, error , 'El error no fue el esperado, fue :' + error);
    }*/
}