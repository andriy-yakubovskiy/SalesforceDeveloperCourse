import { LightningElement, api } from 'lwc';

export default class customPicklist extends LightningElement {
    @api label;
    @api variant;
    @api value;
    @api placeholder;
    @api options;
    @api id;

    handleChange(event) {
        let valueChanging = event.target.value;
        //***Variant with combobox component
        //valueChanging = event.detail.value;
        this.dispatchEvent(new CustomEvent('statuschange', {
                    detail: {
                        id: this.id, 
                        value: valueChanging
                    },
                    bubbles: true,
                    composed: true
                }));
        
    }
}