@isTest
public class getPokemonsTest {
    
    @isTest
    public static void shouldGet1Poke(){
        Pokemon__c miPokeTest = new Pokemon__c();
        miPokeTest.ExtId__c = 1;
        miPokeTest.Altura__c = '50';
        miPoketest.Name = 'pokeName';
        insert miPokeTest;
        
        Test.startTest();
        List<Pokemon__c> pokemonToVerify = getPokemons.getAllPokemons();
        Test.stopTest();
        integer amountOfInsertedPokes = [SELECT COUNT() FROM Pokemon__c];
        system.debug([SELECT Name,Id FROM Pokemon__c]);
        system.assertEquals(1, amountOfInsertedPokes);
        system.assertEquals('pokeName', pokemonToVerify[0].Name);
        system.assertEquals(1, pokemonToVerify[0].ExtId__c);
    }
    @isTest
    public static void shouldGetAuraException(){
        String error = null;
        
        Test.startTest();
        try{
            getPokemons.getAllPokemons();
        } catch (AuraHandledException e) {
            error = e.getMessage();
        }
        Test.stopTest();
        system.assertEquals('No se encontraron Pokemones', error);
    }

}