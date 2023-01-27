import { LightningElement,  } from 'lwc';

export default class MultiPokeTypes extends LightningElement {
    options = [ 
        { label : 'Normal', value : 'normal'},
        { label : 'Fighting', value : 'fighting' },
        { label : 'Flying', value : 'flying'},
        { label : 'Poison', value : 'poison'},
        { label : 'Ground', value : 'ground'},
        { label : 'Rock', value : 'rock'},
        { label : 'Bug', value : 'bug'},
        { label : 'Ghost', value : 'ghost'},
        { label : 'Steel', value : 'steel'},
        { label : 'Fire', value : 'fire'},
        { label : 'Water', value : 'water'},
        { label : 'Grass', value : 'grass'},
        { label : 'Electric', value : 'electric'},
        { label : 'Psychic', value : 'psychic'},
        { label : 'Ice', value : 'ice'},
        { label : 'Dragon', value : 'dragon'},
        { label : 'Dark', value : 'dark'},
        { label : 'Fairy', value : 'fairy'},
    ];
    get max(){
        return 2;
    }
}