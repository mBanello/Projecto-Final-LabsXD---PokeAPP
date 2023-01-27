import { LightningElement } from 'lwc';

export default class PokeComboboxGen extends LightningElement {
    get options() {
        return [
            { label: 'Ninguno', value: '' },
            { label: 'Generacion 1', value: 'gen1' },
            { label: 'Generacion 2', value: 'gen2' },
            { label: 'Generacion 3', value: 'gen3' },
            { label: 'Generacion 4', value: 'gen4' },
            { label: 'Generacion 5', value: 'gen5' },
            { label: 'Generacion 6', value: 'gen6' },
            { label: 'Generacion 7', value: 'gen7' },
            { label: 'Generacion 8', value: 'gen8' },
        ];
    }
}