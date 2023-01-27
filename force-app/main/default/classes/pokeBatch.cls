public with sharing class pokeBatch implements Database.Batchable <Integer>, Database.stateful, 
Database.AllowsCallouts{

public iterable<integer> start(Database.BatchableContext bc){
    List <Integer> idPokemon = new List<Integer>();
    if(Test.isRunningTest()){
        for( integer i = 1; i<=10 ; i++){
            integer n = i;
            idPokemon.add(n);
        }
    } else {
    //898
    for(integer i = 1 ; i<=898 ; i++){
        Integer n = i;
        idPokemon.add(n);
    	}
    }
    return idPokemon;  
}
public void execute (Database.BatchableContext BC, List<integer> valueForCallout){
    List <Pokemon__c> listOfPokemonToInsert = new List <Pokemon__c>();
    for(integer n : valueForCallout){
        String endpoint = 'https://pokeapi.co/api/v2/pokemon/';
        Set<Integer> setOfRandomNumbersForMoves = new Set<Integer>();
        List<Integer> listOfRandomNumbersForMoves = new List<Integer>();
        
        Http http = new http();
        httpRequest request = new HttpRequest();
        request.setEndpoint(endpoint+n);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('accept', 'application/json');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            
            Map<String,Object> newPokeMap = (Map<String,Object>)Json.deserializeUntyped(response.getBody());
            
            Pokemon__c pokemonToInsert = new Pokemon__c();
            
            //EXTID
            pokemonToInsert.ExtId__c = (Integer)newPokeMap.get('id');
            //ALTURA
            pokemonToInsert.Altura__c = ((Integer)newPokeMap.get('height')*10) + ' cm.';
            //PESO
            pokemonToInsert.Peso__c = ((Integer)newPokeMap.get('weight')/10) + ' kgs.';
            //NAME
            String pokeName = (String)newPokeMap.get('name');
            pokemonToInsert.Name = pokeName.capitalize();
            
            //SPRITE 
            Map<String,Object> Sprites = (Map<String,Object>)newPokeMap.get('sprites');
            String URL = (String)Sprites.get('front_default');
            pokemonToInsert.Imagen__c = URL;
            
            //HABILIDAD
            List<Object> abilities = (List<Object>)newPokeMap.get('abilities');
            Integer randomNumber = Integer.valueOf(Math.random() * abilities.size()) ;
            List<Object> habilidades = (List<Object>)newPokeMap.get('abilities');
            Map<String,Object> HabilidadRandom = (Map<String,Object>)habilidades[randomNumber];
            map<String,Object> datosDeHabilidad = (Map<String,Object>)HabilidadRandom.get('ability');
            String nombreHabilidadRandom = (String)datosDeHabilidad.get('name');
            pokemonToInsert.Habilidad__c = [SELECT ID FROM Habilidad__c WHERE Habilidad__c.name =:nombreHabilidadRandom.capitalize()].id;
            
            //TIPOS
            List<Object> Tipos = (List<Object>)newPokeMap.get('types');
            if(Tipos.size() == 1){
                Map<String,Object> Tipo = (Map<String,Object>)Tipos[0];
                Map<String,Object> datosDeTipo = (Map<String,Object>)Tipo.get('type');
                String name = (String)datosDeTipo.get('name');
                pokemonToInsert.Tipos__c = name;
            } else if (Tipos.size() == 2){
                Map<String,Object> Tipo1 = (Map<String,Object>)Tipos[0];
                Map<String,Object> datosDeTipo1 = (Map<String,Object>)Tipo1.get('type');
                String nmbrTipo1 = (String)datosDeTipo1.get('name');
                
                Map<String,Object> Tipo2 = (Map<String,Object>)Tipos[1];
                Map<String,Object> datosDeTipo2 = (Map<String,Object>)Tipo2.get('type');
                String nmbrTipo2 = (String)datosDeTipo2.get('name');
                
                pokemonToInsert.Tipos__c = nmbrTipo1 + ';' + nmbrTipo2;   
            }
            
            //STATS
            List<Object> listOfStats = (List<Object>)newPokeMap.get('stats');
            for(Object obj : listOfStats){
                Map<String,Object> stat = (Map<String,Object>)obj;
                Map<String,Object> datosDeStat = (Map<String,Object>)stat.get('stat');
                String nombreDeStat = (String)datosDeStat.get('name');
                Integer baseStat = (Integer)stat.get('base_stat');
                if(nombreDeStat == 'hp') {
                    pokemonToInsert.Vida__c = baseStat;
                }
                if(nombreDeStat == 'attack') {
                    pokemonToInsert.Ataque__c = baseStat;
                }
                if(nombreDeStat == 'defense') {
                    pokemonToInsert.Defensa__c = baseStat;
                }
                if (nombreDestat == 'speed') {
                    pokemonToInsert.Velocidad__c = baseStat;
                }
              }
            //MOVIMIENTOS
            List<Object> moves = (List<Object>)newPokeMap.get('moves');
            
            Integer amountOfMoves = moves.size();
            
            if(amountOfMoves >=4 ){
                while (setOfRandomNumbersForMoves.size() < 4 ){
                    Integer randomNr = (Integer)(Math.random() * amountOfMoves);
                    setOfRandomNumbersForMoves.add(randomNr);
                }
                for (Integer nr : setOfRandomNumbersForMoves){
                    listOfRandomNumbersForMoves.add(nr);
                }
                Integer Slot1 = listOfRandomNumbersForMoves[0];
                Integer Slot2 = listOfRandomNumbersForMoves[1];
                Integer Slot3 = listOfRandomNumbersForMoves[2];
                Integer Slot4 = listOfRandomNumbersForMoves[3];
                
                Map<String,Object> Habilidad1 = (Map<String,Object>)moves[Slot1];
                Map<String,Object> datosDeHabilidad1 = (Map<String,Object>)Habilidad1.get('move');
                String Move1 = (String)datosDeHabilidad1.get('name');
                
                Map<String,Object> Habilidad2 = (Map<String,Object>)moves[Slot2];
                Map<String,Object> datosDeHabilidad2 = (Map<String,Object>)Habilidad2.get('move');
                String Move2 = (String)datosDeHabilidad2.get('name');
                
                Map<String,Object> Habilidad3 = (Map<String,Object>)moves[Slot3];
                Map<String,Object> datosDeHabilidad3 = (Map<String,Object>)Habilidad3.get('move');
                String Move3 = (String)datosDeHabilidad3.get('name');
                
                Map<String,Object> Habilidad4 = (Map<String,Object>)moves[Slot4];
                Map<String,Object> datosDeHabilidad4 = (Map<String,Object>)Habilidad4.get('move');
                String Move4 = (String)datosDeHabilidad4.get('name');
                
                List<Movimiento__c> idFromMoves = new List<Movimiento__c>(
                    [SELECT id, name FROM Movimiento__c 
                     WHERE Movimiento__c.name =:Move1.capitalize()
                     OR Movimiento__c.name =:Move2.capitalize()
                     OR Movimiento__c.name =:Move3.capitalize()
                     OR Movimiento__c.name =:Move4.capitalize()]
                );
                pokemonToInsert.Slot1__c = idFromMoves[0].id;
                pokemonToInsert.Slot2__c = idFromMoves[1].id;
                pokemonToInsert.Slot3__c = idFromMoves[2].id;
                pokemonToInsert.Slot4__c = idFromMoves[3].id;
            } else {
                List<String> listOfMoves = new List<String>();
                for(integer i = 0; i<amountOfMoves;i++){
                    Map<String,Object>Habilidad = (Map<String,Object>)moves[i];
                    Map<String,Object>nmbrHabilidad = (Map<String,Object>)Habilidad.get('move');
                    String nombreMov = (String)nmbrHabilidad.get('name');
                    listOfMoves.add(nombreMov);  
                }
                if(amountOfMoves == 3){
                    String Move1 = listOfMoves[0];
                    String Move2 = listOfMoves[1];
                    String Move3 = listOfMOves[2];
                    List<Movimiento__c> idForMoves = new List<Movimiento__c>([
                        SELECT id,name FROM Movimiento__c 
                        WHERE Movimiento__c.name =:Move1.capitalize() 
                        OR Movimiento__c.name =:Move2.capitalize() 
                        OR Movimiento__c.name =:Move3.capitalize()
                    ]);
                    pokemonToInsert.Slot1__c = idForMoves[0].id;
                    pokemonToInsert.Slot2__c = idForMoves[0].id;
                    pokemonToInsert.Slot3__c = idForMoves[0].id;
                } else if (amountOfMoves == 2){
                    String Move1 = listOfMoves[0];
                    String Move2 = listOfMoves[1];
                    List<Movimiento__c> idForMoves = new List<Movimiento__c>([
                        SELECT id,name FROM Movimiento__c 
                        WHERE Movimiento__c.name =:Move1.capitalize() 
                        OR Movimiento__c.name =:Move2.capitalize()
                    ]);
                    pokemonToInsert.Slot1__c = idForMoves[0].id;
                    pokemonToInsert.Slot2__c = idForMoves[0].id;
                } else if (amountOfMoves == 1){
                    String Move1 = listOfMoves[0];
                    List<Movimiento__c> idForMoves = new List<Movimiento__c>([
                        SELECT id,name FROM Movimiento__c 
                        WHERE Movimiento__c.name =:Move1.capitalize()
                    ]);
                    pokemonToInsert.Slot1__c = idForMoves[0].id;
                }
            }
            listOfPokemonToInsert.add(pokemonToInsert);
		}
	}
    insert listOfPokemonToInsert;
}



public void finish(Database.BatchableContext BC){
    system.debug('Termino el Batch');
    }
}