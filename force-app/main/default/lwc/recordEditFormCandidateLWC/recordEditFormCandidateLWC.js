import { LightningElement } from 'lwc';
import { NavigationMixin }      from 'lightning/navigation';
import { ShowToastEvent }       from 'lightning/platformShowToastEvent';
import { LABELS }               from 'c/labelUtility';
import saveUpdateRecord         from '@salesforce/apex/GeneralFunctionsMethods.saveUpdateRecord';
import getSettingsForCreateForm from '@salesforce/apex/CandidateControllerDisplay.getAdvancedSettingsForCreationFormCandidate';

export default class RecordEditFormCandidate extends NavigationMixin(LightningElement){
    objectApiName = 'Candidate__c';
    objectApiNameJobApp = 'Job_Application__c';

    labelGlobal = LABELS;

    settingsNameCustomMetadataTypes = 'Settings_for_creation_form_Candidate';

    recordIdofCandidate; 
    recordIdofJobApp;
    
    listFieldsCandidate = [];
    listFieldsJobApp = [];

    showSpinner = false;

    connectedCallback() {
        this.initializeListFields();    
    }

    initializeListFields(){
        this.showSpinner = true;
        this.listFieldsCandidate = [];
        this.listFieldsJobApp = [];
        getSettingsForCreateForm({nameCustomMetadataTypes : this.settingsNameCustomMetadataTypes})
            .then((resultSettings)=>{
                this.showSpinner = false;
                if (JSON.stringify(resultSettings) === '{}') {
                    //Candidate - only name
                    this.listFieldsCandidate.unshift({nameAPI: 'Name',     value: undefined});
                }
                else {
                    //Candidate - all
                    let settingsForCreateForm = resultSettings.informationAboutMetadataObject;
                    let settingsMetadataCandidate = settingsForCreateForm.Candidate__c.settingsMetadata;
                    for (const nameFieldSet in settingsMetadataCandidate) {
                        const listFields = settingsMetadataCandidate[nameFieldSet];
                        let isHaveFieldName = false;
                        let isHaveFieldFirstName = false;
                        let isHaveFieldLastName = false;
                        for (const nameField of listFields) {
                            if(nameField==='Name'){
                                isHaveFieldName = true;
                            }
                            if(nameField==='First_Name__c'){
                                isHaveFieldFirstName = true;
                            }
                            if(nameField==='Last_Name__c'){
                                isHaveFieldLastName = true;
                            }
                            if (settingsForCreateForm.Candidate__c.informationMetadata.labelAndNameFieldsObject.hasOwnProperty(nameField)) {
                                this.listFieldsCandidate.push({nameAPI: nameField,     value: undefined});
                            }
                        }
                        if(!isHaveFieldName && !(isHaveFieldFirstName && isHaveFieldLastName)) {
                            this.listFieldsCandidate.unshift({nameAPI: 'Name',     value: undefined});
                        }
                    }                                
                    //JobApplication
                    let settingsMetadataJobApp = settingsForCreateForm.Job_Application__c.settingsMetadata;
                    for (const nameFieldSet in settingsMetadataJobApp) {
                        const listFields = settingsMetadataJobApp[nameFieldSet];
                        for (const nameField of listFields) {
                            if (settingsForCreateForm.Job_Application__c.informationMetadata.labelAndNameFieldsObject.hasOwnProperty(nameField)) {
                                this.listFieldsJobApp.push({nameAPI: nameField,     value: undefined});
                            }
                        }                    
                    }
                }                
                this.listFieldsCandidate = [...this.listFieldsCandidate];
                this.listFieldsJobApp = [...this.listFieldsJobApp];
            })        
            .catch((error)=>{
                this.showSpinner = false;
                this.listFieldsCandidate = [];
                this.listFieldsJobApp = [];
                console.error(error);
                this.showErrorToast(LABELS.ERROR_LABEL + '!',error.body.message);
            })
    }

    handleChangeFieldCandidate(event){
        this.addFieldTolistFields(this.listFieldsCandidate, event.target.fieldName, event.detail.value);
    }

    handleChangeFieldJobApplication(event){        
        this.addFieldTolistFields(this.listFieldsJobApp, event.target.fieldName, event.detail.value);
    }

    addFieldTolistFields(listFields,nameField, valueField) {
        if (Array.isArray(valueField)){
            for (const elemValueField of valueField) {
                listFields.find(elemList => elemList.nameAPI == nameField).value = elemValueField;    
            }            
        }
        else {
            listFields.find(elemList => elemList.nameAPI == nameField).value = valueField;
        }
    }

    handleSaveModal(event){
        this.submitCandidateAndJobApp();        
    }

    handleCancelModal(event) {
        //to Candidate list view (Recent)
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectApiName,
                actionName: 'list'
            },
            state: {       
                filterName: 'Recent'
            }
        });
    }

    submitCandidateAndJobApp() {
        let isHaveFieldName = false;
        let firstNameCandidate = '';
        let lastNameCandidate = '';
        
        let listFields = [];
        for (const field of this.listFieldsCandidate) {
            listFields.push({[field.nameAPI] : field.value});
            if(field.nameAPI==='Name'){
                isHaveFieldName = true;
            }
            if(field.nameAPI==='First_Name__c'){
                firstNameCandidate = field.value;
            }
            if(field.nameAPI==='Last_Name__c'){
                lastNameCandidate = field.value;
            }
        }
        let nameText  = '';
        if(!isHaveFieldName) {            
            if(firstNameCandidate || lastNameCandidate) {
                nameText = firstNameCandidate + ' ' + lastNameCandidate;
            }             
        }
        if(!nameText) {
            this.showErrorToast(LABELS.ERROR_LABEL + '!','The field "name" of Candidate is missing.');
            return;            
        }
        listFields.push({'Name' : nameText});

        this.showSpinner = true;
        saveUpdateRecord({nameMetadataObject : this.objectApiName, 
                                   strFields : JSON.stringify(listFields), 
                                       idRec : this.recordIdofCandidate})
            .then((result)=>{
                this.showSpinner = false;
                if (result.id!='') {
                    this.recordIdofCandidate = result.id;
                    this.submitJobApp(this.recordIdofCandidate);
                }
                else {
                    this.showErrorToast(LABELS.ERROR_LABEL + '! Can not save object "Candidate"!', result.message);
                    return;
                }                
            })
            .catch((error)=>{
                this.showSpinner = false;
                console.error(error);
                this.showErrorToast(LABELS.ERROR_LABEL + '! Can not save object "Candidate"!', error.body.message);
            })      
    }

    submitJobApp(idCandidate) {
        //Verification Field for full
        let isFieldFull = false;
        for (const field of this.listFieldsJobApp) {
            if (!isFieldFull && Boolean(field.value)) {
                isFieldFull = true;
            }             
        }
        if(!isFieldFull) {
            this.openRecord(idCandidate, this.objectApiName);
            return;
        }
        else {
            let fieldCandidateForJobApp = this.listFieldsJobApp.find(elemList => elemList.nameAPI == 'Candidate__c');
            if (fieldCandidateForJobApp==undefined){
                this.listFieldsJobApp.push({nameAPI:'Candidate__c', value: idCandidate});
            }
            else {
                fieldCandidateForJobApp.value = idCandidate;
            }

            let listFields = [];
            for (const field of this.listFieldsJobApp) {
                listFields.push({[field.nameAPI] : field.value});
            }

            this.showSpinner = true;
            saveUpdateRecord({nameMetadataObject : this.objectApiNameJobApp, 
                                       strFields : JSON.stringify(listFields), 
                                           idRec : this.recordIdofJobApp})
                .then((result)=>{
                    this.showSpinner = false;
                    if (result.id!='') {
                        this.recordIdofJobApp = result.id;                        
                        this.openRecord(idCandidate, this.objectApiName);
                        return;
                    }
                    else {
                        this.showErrorToast(LABELS.ERROR_LABEL + '! Can not save object "Job Applications"!', result.message);
                        return;
                    }
                })
                .catch((error)=>{
                    console.error(error);
                    this.showErrorToast(LABELS.ERROR_LABEL + '! Can not save object "Job Applications"!', error.body.message);
                    return;
                })  
        }      
    }

    openRecord(recordId, apiName) {        
        //to Rec page view
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: apiName,
                actionName: 'view'
            },
        });
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