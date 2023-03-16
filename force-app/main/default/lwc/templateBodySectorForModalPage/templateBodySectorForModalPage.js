import { LightningElement, api } from 'lwc';
import pageTemplateCandidateInformation from './pageCandidateInformation.html';
import pageTemplateSettingsOfCandidate  from './pageCandidateSettings.html';
import getJobApplicationsRecords    from '@salesforce/apex/CandidateControllerDisplay.getJobApplicationsRecordsRelatedCandidate';
import getInfoOfRecord              from '@salesforce/apex/GeneralFunctionsMethods.getInfoOfRecord';

import { LABELS } from 'c/labelUtility';

const NAME_OBJECT_CANDIDATE = 'Candidate__c';

export default class templateBodySectorForModalPage extends LightningElement {
    showTemplate;
    @api paramsPage;
    @api paramsPageSecond;

    structureFieldSetsAndFieldsForCard = [];
    structureFieldSetsAndFieldsForDetail = [];
    structureFieldSetsAndFieldsForJobApp = [];

    additionallyDataForCandidate = [];
    
    namePage = '';
    titleTextPage = '';

    textPlaceholderCombobox = 'Select';
    
    listBlockSetting = [];

    candidateValue = [];

    @api methodReturnActualStructureFieldSetsAndFields(){
        return {structureFieldSetsAndFieldsForCard:this.structureFieldSetsAndFieldsForCard,
                structureFieldSetsAndFieldsForDetail:this.structureFieldSetsAndFieldsForDetail,
                structureFieldSetsAndFieldsForJobApp:this.structureFieldSetsAndFieldsForJobApp };
    }

    connectedCallback(){
        this.paramsPage = JSON.parse(JSON.stringify(this.paramsPage));
        if ((this.paramsPage instanceof Object)){
            if (this.paramsPage['namepage'] != undefined) {
                this.namePage = this.paramsPage['namepage'];
            }
            if (this.paramsPage['bodytext'] != undefined) {
                this.titleTextPage = this.paramsPage['bodytext'];
            }
            this.paramsPageSecond = JSON.parse(JSON.stringify(this.paramsPageSecond));

            if (this.namePage=='candidateSettings') {
                let fieldsetsandfieldsforcard = this.paramsPage['fieldsetsandfieldsforcard'];
                if (fieldsetsandfieldsforcard != undefined) {                    
                    if (Array.isArray(fieldsetsandfieldsforcard)) {
                        this.structureFieldSetsAndFieldsForCard = fieldsetsandfieldsforcard;
                        this.setVisualBlockFieldsSetGroup('forCard','For main card',this.structureFieldSetsAndFieldsForCard);                        
                    }
                }
                let fieldsetsandfieldsfordetail = this.paramsPage['fieldsetsandfieldsfordetail'];
                if (fieldsetsandfieldsfordetail != undefined) {                    
                    if (Array.isArray(fieldsetsandfieldsfordetail)) {
                        this.structureFieldSetsAndFieldsForDetail = fieldsetsandfieldsfordetail;
                        this.setVisualBlockFieldsSetGroup('forDetail','For detail page',this.structureFieldSetsAndFieldsForDetail);
                    }
                }
                let fieldsetsandfieldsforja = this.paramsPage['fieldsetsandfieldsforja'];
                if (fieldsetsandfieldsforja != undefined) {                    
                    if (Array.isArray(fieldsetsandfieldsforja)) {
                        this.structureFieldSetsAndFieldsForJobApp = fieldsetsandfieldsforja;
                        this.setVisualBlockFieldsSetGroup('forDetailJa','For detail JobApp page',this.structureFieldSetsAndFieldsForJobApp);
                    }
                }
            }
            if (this.namePage=='candidateInform') {                
                if (Array.isArray(this.paramsPageSecond)) {
                    let recordId;
                    for (const secondParam of this.paramsPageSecond) {
                        if (secondParam['idowner'] != undefined) {
                            recordId = secondParam['idowner'];
                        }
                    }
                    if (recordId != undefined) {
                        let listFieldsNameVisibleInPage = this.paramsPage['listFieldsNameVisibleInPage'];
                        if (listFieldsNameVisibleInPage != undefined) {
                            this.fetchCandidateRecordInformPage(recordId, listFieldsNameVisibleInPage);
                        }
                        let listFieldsNameVisibleInJA = this.paramsPage['listFieldsNameVisibleInJA'];
                        if (listFieldsNameVisibleInJA != undefined) {
                            this.fetchJaRecordInformPage(recordId, listFieldsNameVisibleInJA);
                        }                        
                    }
                }
            }
        }        
    }

    fetchJaRecordInformPage(recordId, listFieldsNameVisible){
        getJobApplicationsRecords({idCandidate : recordId,
                                    listNameFields : listFieldsNameVisible})
            .then((result)=>{
                this.additionallyDataForCandidate = [...result];                
            })
            .catch((error)=>{
                this.additionallyDataForCandidate = [];
                console.error(error);
                this.showErrorToast(LABELS.ERROR_LABEL + ' ' + LABELS.GET_LABEL + ' ' + LABELS.THE_LABEL.toLowerCase() + ' ' + LABELS.DATA_LABEL.toLowerCase()+'!',error.body.message);
            }); 
    }

    fetchCandidateRecordInformPage(recordId, listFieldsNameVisible){
        this.candidateValue = [];        
        getInfoOfRecord({metadataNameObject : NAME_OBJECT_CANDIDATE,
                                    idRecordObject : recordId,
                                        listNameFields : listFieldsNameVisible})
            .then((result)=>{
                this.candidateValue = result;
            })
            .catch((error)=>{
                this.candidateValue = [];
                console.error(error);
                this.showErrorToast(LABELS.ERROR_LABEL + ' ' + LABELS.GET_LABEL + ' ' + LABELS.THE_LABEL.toLowerCase() + ' ' + LABELS.DATA_LABEL.toLowerCase()+'!',error.body.message);
            })
    }

    render(){
        if (this.namePage=='candidateSettings') {
            this.showTemplate = pageTemplateSettingsOfCandidate;
        }
        if (this.namePage=='candidateInform') {
            this.showTemplate = pageTemplateCandidateInformation;
        }               
        return this.showTemplate;
    }

    setUsedFieldSetAndFieldsInStructure(nameActiveFieldSet,newMapActiveFields,structureFieldSetsAndFields){
        //FieldSet
        for(const objFieldSet of structureFieldSetsAndFields){
            const nameFieldSet = Object.keys(objFieldSet)[0];
            objFieldSet[nameFieldSet].used = (nameActiveFieldSet==nameFieldSet);
            if (objFieldSet[nameFieldSet].used && newMapActiveFields!=undefined) {                
                //Fields in FieldSet
                for(const objField of objFieldSet[nameFieldSet].fields){
                    const nameField = Object.keys(objField)[0];
                    let valueUsedField = newMapActiveFields.get(nameField);
                    if(valueUsedField!=undefined) {
                        objField[nameField].used = valueUsedField;
                    }
                }                
            }
        }
        structureFieldSetsAndFields = [...structureFieldSetsAndFields];
    }

    objStructureBlock(name,nameCombobox,labelCombobox,listOptionsCombobox,selectedValueCombobox,nameCheckbox,listOptionsCheckbox){
        return {name,
                nameCombobox,
                labelCombobox,
                listOptionsCombobox,
                selectedValueCombobox,
                nameCheckbox,
                listOptionsCheckbox
                };
    }

    setVisualBlockFieldsSetGroup(nameGroup, lableGroup, structureFieldSets){
        let visualDataGroupForDispley = this.getVisualDataFieldsSetGroup(structureFieldSets);        
        
        let objectBlock = this.objStructureBlock(nameGroup,nameGroup,lableGroup,
            visualDataGroupForDispley.optionsCombobox,
            visualDataGroupForDispley.valueCombobox,
            nameGroup,
            visualDataGroupForDispley.optionsCheckbox);

        let isUpp = false;
        this.listBlockSetting = this.listBlockSetting.map((blockSetting) => {
                                                        if (blockSetting.hasOwnProperty('name') && blockSetting.name == nameGroup){
                                                            isUpp = true;
                                                            blockSetting = objectBlock; 
                                                            }
                                                        return blockSetting;                
                                                        }
                                                    ); 
        if(!isUpp){                        
            this.listBlockSetting.push(objectBlock);
        }
    }

    getVisualDataFieldsSetGroup(structureFieldSets){
        //Combobox - field set
        let listOptionsCombobox = [];
        let selectedValueCombobox = '';
        for(const objFieldSet of structureFieldSets){
            let nameFieldSet = Object.keys(objFieldSet)[0];                        
            listOptionsCombobox.push({ label: nameFieldSet, value: nameFieldSet });
            let settingsFieldSet = objFieldSet[nameFieldSet];
            if (settingsFieldSet.used && selectedValueCombobox.trim().length === 0) {
                selectedValueCombobox = nameFieldSet;
            }
        }        
        listOptionsCombobox.unshift({ label: '-', value: 'empty' });
        if (selectedValueCombobox.trim().length === 0) {
            selectedValueCombobox = 'empty';
        }
        
        //Checkbox - fields
        let selectedNameFieldSet = selectedValueCombobox;
        let listOptionsCheckbox = [];
        if(selectedNameFieldSet!='empty'){
            let settingsFieldSet = undefined;
            for(const objFieldSet of structureFieldSets){
                if(settingsFieldSet==undefined){
                    settingsFieldSet = objFieldSet[selectedNameFieldSet]; 
                }
            }
            if(settingsFieldSet!=undefined){
                for(const objField of settingsFieldSet.fields){
                    let nameField = Object.keys(objField)[0];
                    let settingsField = objField[nameField];
                    listOptionsCheckbox.push({checked: settingsField.accessible?settingsField.used:false, disabled: !settingsField.accessible, label: settingsField.lableField, value: nameField});
                }
            }
        }
        return {optionsCombobox:listOptionsCombobox, valueCombobox:selectedValueCombobox, optionsCheckbox:listOptionsCheckbox};
    }

    handleChangeComboboxSetting(event){
        let nameblock = event.target.name;
        let nameFieldSet = event.detail.value;
        
        if (nameblock=='forCard') {
            this.setUsedFieldSetAndFieldsInStructure(nameFieldSet,undefined,this.structureFieldSetsAndFieldsForCard);
            this.setVisualBlockFieldsSetGroup(nameblock,'For main card',this.structureFieldSetsAndFieldsForCard);
        }
        if (nameblock=='forDetail') {            
            this.setUsedFieldSetAndFieldsInStructure(nameFieldSet,undefined,this.structureFieldSetsAndFieldsForDetail);
            this.setVisualBlockFieldsSetGroup(nameblock,'For detail page',this.structureFieldSetsAndFieldsForDetail);
        }
        if (nameblock=='forDetailJa') {
            this.setUsedFieldSetAndFieldsInStructure(nameFieldSet,undefined,this.structureFieldSetsAndFieldsForJobApp);
            this.setVisualBlockFieldsSetGroup(nameblock,'For detail JobApp page',this.structureFieldSetsAndFieldsForJobApp);
        }
    }

    handleChangesCheckboxSetting(event){
        let nameblock = event.target.dataset.checkboxBlock;
        let nameFieldSet = event.target.dataset.valueComboboxBlock;
        
        let nameField = event.target.name;
        let checkedField = event.target.checked;

        let activeFields = new Map();    
        activeFields.set(nameField,checkedField);

        if (nameblock=='forCard') {
            this.setUsedFieldSetAndFieldsInStructure(nameFieldSet,activeFields,this.structureFieldSetsAndFieldsForCard);
        }
        if (nameblock=='forDetail') {
            this.setUsedFieldSetAndFieldsInStructure(nameFieldSet,activeFields,this.structureFieldSetsAndFieldsForDetail);
        }
        if (nameblock=='forDetailJa') {
            this.setUsedFieldSetAndFieldsInStructure(nameFieldSet,activeFields,this.structureFieldSetsAndFieldsForJobApp);
        }
    }

    showErrorToast(textTitle,textMsg) {
        try {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: textTitle,
                    message: textMsg,
                    variant: 'error',
                    mode: 'dismissable'
                })
             );
        } catch (error) {
            console.error(error);
        }
    }
}