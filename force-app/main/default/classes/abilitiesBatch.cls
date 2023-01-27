public with sharing class abilitiesBatch implements Database.Batchable <Integer>, Database.stateful, 
Database.AllowsCallouts{
    
    public iterable<integer> start(Database.BatchableContext bc){
        List<Integer> idAbility= new List<Integer>();
        if(Test.isRunningTest()){
            for(Integer i =1 ; i<=1;i++){
                integer n = i;
                idAbility.add(n);
            }
        } else {
            
            for(Integer i =1 ; i<=267;i++){
                integer n = i;
                idAbility.add(n);
        	} 
    	}
        return idAbility;
    }

    public void execute (Database.BatchableContext BC, List<integer> valueForCallout) {
        List <Habilidad__c> listOfAbilitiesToInsert = new List <Habilidad__c>();
        
        for(integer n : valueForCallout){
            String endpoint = 'https://pokeapi.co/api/v2/ability/';
            Http http = new http();
            httpRequest request = new HttpRequest();
            request.setEndpoint(endpoint+n);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('accept', 'application/json');
            HttpResponse response = http.send(request);
            
            if ( response.getStatusCode() != 200 ){
                throw new CalloutException('Error : ' + response.getBody());
            	} else {
                ability newAbility = ability.parse(response.getBody());
                
                Habilidad__c abilityToInsert = new Habilidad__c();
                abilityToInsert.Name = newAbility.name.capitalize();
                abilityToInsert.ExtId__c = newAbility.id;
                if (newAbility.effect_entries.size() > 0){
                    for(ability.Effect_entries_Z listOfEffects : newAbility.effect_entries){
                        if(listOfEffects.language.name == 'en'){
                            if(listOfEffects.short_effect == 'null'){
                                abilityToInsert.Efecto__c ='Sin efecto';
                            } else {
                            abilityToInsert.Efecto__c = ListOfEffects.short_effect;
                            }
                        }  
                    }    
                }
                listOfAbilitiesToInsert.add(abilityToInsert);    
            }
        }
        try {
            insert listOfAbilitiesToInsert;
        } catch (Exception e) {
            system.debug(e);
        }   
    }
    public void finish(Database.BatchableContext BC){
        system.debug('Termino el Batch');
    }
}