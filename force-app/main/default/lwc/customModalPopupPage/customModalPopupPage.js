import { LightningElement, api } from 'lwc';

export default class customModalPopup extends LightningElement {
    @api variantOpenButton;
    @api labelOpenButton;
    @api paramsPage;
    @api idObjectOwner;
    paramsPageSecond = [];
    headerText = '';    

    namePage = '';

    fieldsetsandfieldsforcard = [];
    fieldsetsandfieldsfordetail = [];

    isModalOpen = false;
    showButtonCancel = false;
    
    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    okModal() {
        this.isModalOpen = false;

        if (this.namePage=='candidateSettings') {
            let actualStructureFieldSetsAndFields = this.template.querySelector('c-template-body-sector-for-modal-page').methodReturnActualStructureFieldSetsAndFields();
            actualStructureFieldSetsAndFields = JSON.parse(JSON.stringify(actualStructureFieldSetsAndFields));
            if(actualStructureFieldSetsAndFields instanceof Object) {  
                this.dispatchEvent(new CustomEvent('submitdetailsmodalpage', { 
                                                                                detail: {
                                                                                    'newStructureListOfFieldSets' : actualStructureFieldSetsAndFields
                                                                                        } 
                                                                             }));
            };
        }
    }

    connectedCallback() {
        this.paramsPage = JSON.parse(JSON.stringify(this.paramsPage));
        if (this.paramsPage instanceof Object){
            if (this.paramsPage['headertext'] != undefined) {
                this.headerText = this.paramsPage['headertext'];
            }
            if (this.paramsPage['namepage'] != undefined) {
                this.namePage = this.paramsPage['namepage'];
            }
            if (this.namePage=='candidateSettings') {
                this.showButtonCancel = true;
            }
            if (this.namePage=='candidateInform') {
                if (!Array.isArray(this.paramsPageSecond)){
                    this.paramsPageSecond = [];
                }
                this.paramsPageSecond.push({'idowner' : this.idObjectOwner});
            }
        }
    }
}