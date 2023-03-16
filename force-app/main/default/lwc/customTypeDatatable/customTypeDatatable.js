import LightningDatatable from 'lightning/datatable';
import PicklistTemplate from './customPicklistTemplate.html';

export default class customTypeDatatable extends LightningDatatable {
    static customTypes = {
        statusPicklist:{
            standardCellLayout: true,
            template: PicklistTemplate,            
            typeAttributes:['label', 'variant', 'value', 'placeholder', 'options', 'id']
        }
    }
}