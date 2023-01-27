public with sharing class movesBatch implements Database.Batchable <Integer>, Database.stateful, 
Database.AllowsCallouts
{
    
    public iterable<integer> start(Database.BatchableContext bc){
        List <Integer> idMove = new List<Integer>();
        if(Test.isRunningTest()){
            for(integer i = 1; i<=10; i++){
                Integer n = 1;
                idMove.add(n);
            }
        } else {
        	for(integer i = 1 ; i<=826 ; i++){
                Integer n = i;
                idMove.add(n);
            }
        }
        return idMove;  
    }
    public void execute (Database.BatchableContext BC, List<integer> valueForCallout) {
        List <Movimiento__c> listOfMovesToInsert = new List <Movimiento__c>();
        
        for(integer n : valueForCallout){
            String endpoint = 'https://pokeapi.co/api/v2/move/';
            Http http = new http();
            httpRequest request = new HttpRequest();
            request.setEndpoint(endpoint+n);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('accept', 'application/json');
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() != 200) {
                throw new CalloutException('Error : ' + response.getBody());
            } 
            else {
                move newMove = move.parse(response.getBody());
                Movimiento__c moveToInsert = new Movimiento__c();
                moveToInsert.ExtId__c = newMove.id;
                if(newMove.accuracy != null){
                    moveToInsert.Punteria__c = (Integer)newMove.accuracy;
                }
                if(newMove.effect_chance != null){
                    moveToInsert.Chance_de_Efecto__c = (Integer)newMove.effect_chance + '%';
                }
                if(newMove.target.name != 'null'){
                    moveToInsert.Objetivo__c = newMove.target.name.capitalize();
                } else {
                    moveToInsert.Objetivo__c = 'Sin Objetivo';
                }
                if(newMove.priority != null){
                    moveToInsert.Prioridad__c = newMove.priority;
                }
                
                if(newMove.effect_entries.size()>0){
                    for(move.effect_entries listOfEffects : newMove.effect_entries){
                        if(listOfEffects.language.name == 'en') {
                            moveToInsert.Efecto__c = listOfEffects.short_effect;
                        }
                    }
                }
                moveToInsert.Name = newMove.name.capitalize();
                if(newMove.power != null){
                    moveToInsert.Poder__c = (Integer)newMove.power;
                }
                
                moveToInsert.Pp__c = newMove.pp;
                moveToInsert.Tipo__c = newMove.type.name.capitalize();
                ListOfMovesToInsert.add(moveToInsert);
                
            }  
        }
        
        try {
            insert ListOfMovesToInsert;
        } catch (Exception e) {
            system.debug(e);
        }
        
	}
            
            
    public void finish(Database.BatchableContext BC){
        system.debug('Termino el Batch');
	}
}