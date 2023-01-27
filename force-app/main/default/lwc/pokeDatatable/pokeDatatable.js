import { LightningElement, wire, api } from 'lwc';
import getAllPokemons from '@salesforce/apex/getPokemons.getAllPokemons';
import {NavigationMixin} from 'lightning/navigation';




const columns = [
    { label: 'Nombre de Pokemon',fieldName: 'Name', type: 'button', initialWidth: 220, typeAttributes: {
        label: { fieldName: 'Name'}, name: 'redirectPoke',variant :'base'
    }},
    { label: 'ID', fieldName: 'ExtId__c',initialWidth: 60},
    { label: 'Tipos', fieldName: 'Tipos__c', initialWidth: 120, type: 'text'},
    { label: 'Generacion', fieldName: 'Generacion__c', initialWidth: 100},
    { label: 'Habilidad',fieldName: 'abilityName', type: 'button', initialWidth: 220, typeAttributes: {
        label: {fieldName: 'abilityName'}, name: 'redirectAbility',variant :'base'  
    }},
    { label: 'Altura', fieldName: 'Altura__c', initialWidth: 100},
    { label: 'Peso', fieldName: 'Peso__c', initialWidth: 100},
    { label: 'Vida', fieldName: 'Vida__c', initialWidth: 100},
    { label: 'Ataque', fieldName: 'Ataque__c', initialWidth: 100},
    { label: 'Defensa', fieldName: 'Defensa__c', initialWidth: 100},
    { label: 'Velocidad', fieldName: 'Velocidad__c', initialWidth: 100},
    { label: 'Imagen', fieldName: 'Imagen__c', type:'image', initialWidth: 180},
    
];

export default class PokeDatatable extends NavigationMixin(LightningElement) {

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch(actionName) {
            case 'redirectPoke':
                this.redirectToPokeRecPage(row);
                break;
            case 'redirectAbility':
                this.redirectToAbilityRecPage(row);
                break;
            default:
        }

    }

    redirectToPokeRecPage(row){
        this.record = row
        this[NavigationMixin.Navigate]({
            type : 'standard__recordPage',
            attributes: {
                recordId: this.record.Id,
                actionName:'view'
            }
        });
    }
    redirectToAbilityRecPage(row){
        this.record = row
        this[NavigationMixin.Navigate]({
            type : 'standard__recordPage',
            attributes: {
                recordId: this.record.Habilidad__c,
                actionName:'view'
            }
        });
    }

    pokemonsShowingInDatatable = [];
    pokemons = [];
    error;
    columns = columns;
    initialRecords;
    filterByInput = '';
    filterByType= '';
    filterByGen='';
    type1;
    type2;
    cantDeRegistros = '898';


    
    
    
    @wire ( getAllPokemons )
    wiredPokemons( { error,data } ) {
        if ( data ) {
            this.pokemons = data;
            this.initialRecords = data;
            this.assignAbilities();
            this.error = undefined;
            this.actualizarPagina();
            
        } else if ( error ) {

            this.error = error;
            this.pokemons = undefined;
        }
    }
    assignAbilities(){
        this.pokemonsShowingInDatatable = this.pokemons.map(row => {
            const abilityName = row.Habilidad__r.Name;
            return {...row ,abilityName };
        })
    }
    handleInputSimultaneously( event ) {
        this.filterByInput = event.detail.value
        if(this.filterByType.length == 0 || this.filterByType == ''){
            this.pokemons = this.initialRecords.filter (
                record => (record.Name.toLowerCase().includes(this.filterByInput.toLocaleLowerCase()))
                ).filter(
                    record=> (record.Generacion__c.toLowerCase().includes(this.filterByGen))
                );
        } else if (this.filterByType.length == 1){
            this.type1 = this.filterByType[0];
            this.pokemons = this.initialRecords.filter(
                    record => ( record.Tipos__c.toLowerCase().includes(this.type1))
                ).filter(
                    record => ( record.Name.toLowerCase().includes(this.filterByInput.toLowerCase()))
                ).filter(
                    record => (record.Generacion__c.toLocaleLowerCase().includes(this.filterByGen))
                );
        } else if (this.filterByType.length == 2){
            this.type1 = this.filterByType[0];
            this.type2 = this.filterByType[1];
            this.pokemons = this.initialRecords.filter(
                    record => ( record.Tipos__c.toLowerCase().includes(this.type1))
                ).filter(
                    record => ( record.Tipos__c.toLowerCase().includes(this.type2))
                ).filter(
                    record => ( record.Name.toLowerCase().includes(this.filterByInput.toLowerCase()))
                ).filter(
                    record => (record.Generacion__c.toLocaleLowerCase().includes(this.filterByGen))
                );
        }
        this.cantDeRegistros = this.pokemons.length;
        this.assignAbilities();
        this.actualizarPagina();
        this.primerPagina();
    }

    handleMultiBoxSimultaneously( event ) {
        this.filterByType = event.detail.value;
        if(this.filterByType.length == 0 || this.filterByType == ''){
            this.pokemons = this.initialRecords.filter (
                record => (record.Name.toLowerCase().includes(this.filterByInput.toLocaleLowerCase()))
                ).filter(
                    record=> (record.Generacion__c.toLowerCase().includes(this.filterByGen))
                );
        } else if (this.filterByType.length == 1){
            this.type1 = this.filterByType[0];
            this.pokemons = this.initialRecords.filter(
                    record => ( record.Tipos__c.toLowerCase().includes(this.type1))
                ).filter(
                    record => ( record.Name.toLowerCase().includes(this.filterByInput.toLowerCase()))
                ).filter(
                    record => (record.Generacion__c.toLocaleLowerCase().includes(this.filterByGen))
                );
        } else if (this.filterByType.length == 2){
            this.type1 = this.filterByType[0];
            this.type2 = this.filterByType[1];
            this.pokemons = this.initialRecords.filter(
                    record => ( record.Tipos__c.toLowerCase().includes(this.type1))
                ).filter(
                    record => ( record.Tipos__c.toLowerCase().includes(this.type2))
                ).filter(
                    record => ( record.Name.toLowerCase().includes(this.filterByInput.toLowerCase()))
                ).filter(
                    record => (record.Generacion__c.toLocaleLowerCase().includes(this.filterByGen))
                );
        }
        this.cantDeRegistros = this.pokemons.length;
        this.assignAbilities();
        this.actualizarPagina();
        this.primerPagina();
    }

handleGen( event ) {
    this.filterByGen = event.detail.value;
    if(this.filterByType.length == 0 || this.filterByType == ''){
        this.pokemons = this.initialRecords.filter (
            record => (record.Name.toLowerCase().includes(this.filterByInput.toLocaleLowerCase()))
            ).filter(
                record=> (record.Generacion__c.toLowerCase().includes(this.filterByGen))
            );
    } else if (this.filterByType.length == 1){
        this.type1 = this.filterByType[0];
        this.pokemons = this.initialRecords.filter(
                record => ( record.Tipos__c.toLowerCase().includes(this.type1))
            ).filter(
                record => ( record.Name.toLowerCase().includes(this.filterByInput.toLowerCase()))
            ).filter(
                record => (record.Generacion__c.toLocaleLowerCase().includes(this.filterByGen))
            );
    } else if (this.filterByType.length == 2){
        this.type1 = this.filterByType[0];
        this.type2 = this.filterByType[1];
        this.pokemons = this.initialRecords.filter(
                record => ( record.Tipos__c.toLowerCase().includes(this.type1))
            ).filter(
                record => ( record.Tipos__c.toLowerCase().includes(this.type2))
            ).filter(
                record => ( record.Name.toLowerCase().includes(this.filterByInput.toLowerCase()))
            ).filter(
                record => (record.Generacion__c.toLocaleLowerCase().includes(this.filterByGen))
            );
    }
    this.cantDeRegistros = this.pokemons.length;
    this.assignAbilities();
    this.actualizarPagina();
    this.primerPagina();
}


nrDePagina = 0
datosDePagina = []

actualizarPagina() {
    this.datosDePagina = this.pokemonsShowingInDatatable.slice(this.nrDePagina*10, this.nrDePagina*10+10)
}

paginaAnterior() {
    this.nrDePagina = Math.max(0, this.nrDePagina - 1)
    this.actualizarPagina()
}

primerPagina() {
    this.nrDePagina = 0;
    this.actualizarPagina()
}

  paginaSiguiente() {
    this.nrDePagina = Math.min(Math.floor((this.pokemonsShowingInDatatable.length-9)/10), this.nrDePagina + 1)
    this.actualizarPagina()
}

ultimaPagina() {
    this.nrDePagina = Math.ceil((this.pokemonsShowingInDatatable.length-9)/10)
    this.actualizarPagina()
}
}