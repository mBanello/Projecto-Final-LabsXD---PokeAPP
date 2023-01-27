public with sharing class getPokemons {
    
    @AuraEnabled(cacheable = true)
    public static List<Pokemon__c> getAllPokemons() {
        
        List<Pokemon__c> Pokemons = new List<Pokemon__c>();
        Pokemons = [SELECT Id,
                            Pokemon__c.ExtId__c,
                            Name,
                            Pokemon__c.Generacion__c,
                            Pokemon__c.Altura__c,
                            Pokemon__c.Peso__c,
                            Pokemon__c.Tipos__c,
                            Pokemon__c.Imagen__c,
                            Pokemon__c.Vida__c,
                            Pokemon__c.Defensa__c,
                            Pokemon__c.Ataque__c,
                            Pokemon__c.Velocidad__c,
                            Pokemon__c.Slot1__c,
                            Pokemon__c.Slot2__c,
                            Pokemon__c.Slot3__c,
                            Pokemon__c.Slot4__c,
                            Pokemon__c.Habilidad__c,
                            Habilidad__r.name 
                    FROM Pokemon__c 
                    ORDER BY ExtId__c 
                    ASC];
        if(Pokemons.isEmpty()){
            String error = 'No se encontraron Pokemones';
            AuraHandledException e = new AuraHandledException(error);
            e.setMessage(error);
            throw e;
        }
        return Pokemons;
    }
}