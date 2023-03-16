import { LightningElement, api }       from 'lwc';
import getCandidateRecords             from '@salesforce/apex/CandidateControllerDisplay.getCandidateRecordsRelatedPosition';
import insertAndUpdateCustomMetadata   from '@salesforce/apex/GeneralFunctionsMethods.saveInsertAndUpdateCustomMetadataTypes';
import getAdvancedSettingsForDisplaying from '@salesforce/apex/CandidateControllerDisplay.getAdvancedSettingsForDisplayingCandidatesInPositionsPage';

import { LABELS } from 'c/labelUtility';

const NAME_OBJECT_CANDIDATE = 'Candidate__c';

export default class CandidatesOnPositionPage extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api flexipageRegionWidth;

    settingsNameCustomMetadataTypes = 'Extra_settings_on_position_extended_page';
    userType = '';
    isAdmin = false;

    isFirstRenderPage = true;
    classNameSizeCard = '';

    loadingCandidatesList = false;
    emptyCandidatesList = false;
    candidates = [];

    listFieldsNameVisibleInMainPage = [];
    listFieldsNameRequired = ['Id','Name'];

    @api numberOfRecordsInPage;
    startRecord = 1; 
    totalRecords = 0;
    
    labelOpenButtonModalPopupPageSettings = 'Settings';
    parametersModalPopupPageSettings = {namepage   : 'candidateSettings'
                                       ,headertext : 'Settings'
                                       ,bodytext   : 'Select:'
                                       };

    labelOpenButtonModalPopupPageInform = 'View More';
    parametersModalPopupPageInform = {namepage   : 'candidateInform'
                                     ,headertext : 'Information of candidate'
                                     ,bodytext   : 'Candidate and job application'
                                     };

    renderedCallback() {
        if (this.isFirstRenderPage) {
            this.isFirstRenderPage = false;
            this.classNameSizeCard = 'slds-col slds-size_1-of-'+this.numberOfRecordsInPage;            
        } 
    }

    connectedCallback(){
        this.fetchInformationsMetadataAndRecordsOfCandidate();
    }

    fetchInformationsMetadataAndRecordsOfCandidate(){
        this.listFieldsNameVisibleInMainPage = [];
        getAdvancedSettingsForDisplaying({nameCustomMetadataTypes : this.settingsNameCustomMetadataTypes})
            .then((resultAdvancedSettings)=>{
                this.userType = resultAdvancedSettings.userType;
                this.isAdmin = resultAdvancedSettings.infoOfUser.isAdmin;
                let structureFieldSet = this.getStructureFieldSetAndFields(resultAdvancedSettings);
                let structureFieldSetCandidateCard  = structureFieldSet.structureFieldSetCandidateCard;
                let structureFieldSetCandidatePopup = structureFieldSet.structureFieldSetCandidatePopup;
                let structureFieldSetJobAppPopup    = structureFieldSet.structureFieldSetJobAppPopup;

                this.listFieldsNameVisibleInMainPage    = this.createVisualListFieldsForPage(structureFieldSetCandidateCard);
                let listFieldsNameVisibleInDetailPage   = this.createVisualListFieldsForPage(structureFieldSetCandidatePopup);
                let listFieldsNameVisibleInDetailPageJA = this.createVisualListFieldsForPage(structureFieldSetJobAppPopup);

                this.parametersModalPopupPageSettings = {...this.parametersModalPopupPageSettings, 
                                                            'fieldsetsandfieldsforcard' : structureFieldSetCandidateCard,
                                                            'fieldsetsandfieldsfordetail' : structureFieldSetCandidatePopup,
                                                            'fieldsetsandfieldsforja' : structureFieldSetJobAppPopup
                                                            };
                    
                this.parametersModalPopupPageInform = {...this.parametersModalPopupPageInform, 
                                                            'fieldsetsandfieldsfordetail' : structureFieldSetCandidatePopup,
                                                            'listFieldsNameVisibleInPage' : listFieldsNameVisibleInDetailPage,
                                                            'listFieldsNameVisibleInJA' : listFieldsNameVisibleInDetailPageJA
                                                            };

                this.fetchCandidateRecords();                            
        })       
    }

    getStructureFieldSetAndFields(advancedSettings) {
        let structureFieldSetCandidateCard=[];
        let structureFieldSetCandidatePopup=[];
        let structureFieldSetJobAppPopup=[];
        
        let informationAboutMetadataObject = advancedSettings.informationAboutMetadataObject;
        for (const nameObject in informationAboutMetadataObject) {
            let aboutObject = informationAboutMetadataObject[nameObject];
            let informationMetadata = aboutObject.informationMetadata;
            //let labelAndNameFieldsObject = informationMetadata.labelAndNameFieldsObject;
                        
            let settingsCustomMetadata = aboutObject.settingsMetadata;

            //card
            if(nameObject == 'Candidate__c' && settingsCustomMetadata.hasOwnProperty('card')) {
                structureFieldSetCandidateCard = this.getListFieldsInFieldSet(settingsCustomMetadata.card,informationMetadata.labelAndNameFieldsFieldSet,informationMetadata.accessPropertiesObject);
            }

            //popup
            if(settingsCustomMetadata.hasOwnProperty('popup')) {
                if(nameObject == 'Candidate__c') {
                    structureFieldSetCandidatePopup = this.getListFieldsInFieldSet(settingsCustomMetadata.popup,informationMetadata.labelAndNameFieldsFieldSet,informationMetadata.accessPropertiesObject);
                }
                if(nameObject == 'Job_Application__c') {
                    structureFieldSetJobAppPopup = this.getListFieldsInFieldSet(settingsCustomMetadata.popup,informationMetadata.labelAndNameFieldsFieldSet,informationMetadata.accessPropertiesObject);
                }
            }                                        
        }
        
        return {structureFieldSetCandidateCard,structureFieldSetCandidatePopup,structureFieldSetJobAppPopup};
    }

    getListFieldsInFieldSet(fieldSetFromSettings, labelAndNameFieldsFieldSet, accessFieldProperties){
        let structureFieldSet = [];
        for (const nameFieldSet in labelAndNameFieldsFieldSet) {
            let usedFieldSet = fieldSetFromSettings.hasOwnProperty(nameFieldSet);
            
            let arrayNameFieldsFromFieldSetSettings = [];
            if(usedFieldSet) {
                arrayNameFieldsFromFieldSetSettings = fieldSetFromSettings[nameFieldSet];
            }
            let listNameAndLableFieldsFromFieldSet = labelAndNameFieldsFieldSet[nameFieldSet];                
            
            let listStructureFields = [];
            for (const nameFieldsOfFieldSet in listNameAndLableFieldsFromFieldSet) {
                let labelFields = listNameAndLableFieldsFromFieldSet[nameFieldsOfFieldSet];
                let usedField = arrayNameFieldsFromFieldSetSettings.includes(nameFieldsOfFieldSet);
                listStructureFields.push({[nameFieldsOfFieldSet] : {'used':usedField, 'nameField':nameFieldsOfFieldSet, 'lableField':labelFields, 'accessible':accessFieldProperties.accessibleFields[nameFieldsOfFieldSet]}});
            }
            structureFieldSet.push({[nameFieldSet] : {'used' : usedFieldSet, 'fields' : listStructureFields}});            
        }
        
        return structureFieldSet;
    }

    fetchCandidateRecords(){
        this.loadingCandidatesList = true;        
        this.candidates = [];
        getCandidateRecords({metadataNameCandidate : NAME_OBJECT_CANDIDATE,
                                idPosition : this.recordId,
                                    listNameFields : this.listFieldsNameVisibleInMainPage, 
                                        startFromRecord : this.startRecord, 
                                            quantityRecords: this.numberOfRecordsInPage})
            .then((result)=>{
                this.totalRecords   = result.countRecords;
                this.candidates     = result.listRecords;
                this.candidates = this.candidates.map(
                                                    (record)=>{ 
                                                                return {
                                                                        ...record,
                                                                        link : '/'+record.id
                                                                        }                
                                                            }
                                                    );                                
                this.candidates = [...this.candidates];
                
                this.emptyCandidatesList = (this.candidates.length==0);
                this.loadingCandidatesList = false;
            })
            .catch((error)=>{
                this.loadingCandidatesList = false;
                this.emptyCandidatesList = true;                
                this.candidates = [];
                console.error(error);
                this.showErrorToast(LABELS.ERROR_LABEL + ' ' + LABELS.GET_LABEL + ' ' + LABELS.THE_LABEL.toLowerCase() + ' ' + LABELS.DATA_LABEL.toLowerCase()+'!',error.body.message);
            })
    }

    createVisualListFieldsForPage(currentStructureListOfFieldSets){
        let listFieldsName = []; 
        for(const objFieldSet of currentStructureListOfFieldSets){
            let nameFieldSet = Object.keys(objFieldSet)[0];
            let valueFieldSet = objFieldSet[nameFieldSet];
            if(valueFieldSet.used){
                for(const objField of valueFieldSet.fields){
                    let nameField = Object.keys(objField)[0];
                    let valueField = objField[nameField];
                    if(valueField.used && !(listFieldsName.includes(nameField))){
                        listFieldsName.push(nameField);
                    }
                }
            }            
        }
        return this.listFieldsNameRequired.concat(listFieldsName);
    }

    handleChangedParametersPageSettings(event){
        let newStructureListOfFieldSets = JSON.parse(JSON.stringify(event.detail.newStructureListOfFieldSets));
        if(newStructureListOfFieldSets instanceof Object) {
            let currentStructureListOfFieldSetsForCard     = [...newStructureListOfFieldSets.structureFieldSetsAndFieldsForCard];
            let currentStructureListOfFieldSetsForDetail   = [...newStructureListOfFieldSets.structureFieldSetsAndFieldsForDetail];
            let currentStructureListOfFieldSetsForJA       = [...newStructureListOfFieldSets.structureFieldSetsAndFieldsForJobApp];

            this.listFieldsNameVisibleInMainPage = this.createVisualListFieldsForPage(currentStructureListOfFieldSetsForCard);
            let listFieldsNameVisibleInDetailPage = this.createVisualListFieldsForPage(currentStructureListOfFieldSetsForDetail);
            let listFieldsNameVisibleInDetailPageJA = this.createVisualListFieldsForPage(currentStructureListOfFieldSetsForJA);

            this.parametersModalPopupPageSettings = {...this.parametersModalPopupPageSettings, 
                                                    'fieldsetsandfieldsforcard' : currentStructureListOfFieldSetsForCard,
                                                    'fieldsetsandfieldsfordetail' : currentStructureListOfFieldSetsForDetail,
                                                    'fieldsetsandfieldsforja' : currentStructureListOfFieldSetsForJA
                                                    };
            
            this.parametersModalPopupPageInform = {...this.parametersModalPopupPageInform, 
                                                  'fieldsetsandfieldsfordetail' : currentStructureListOfFieldSetsForDetail,
                                                  'listFieldsNameVisibleInPage' : listFieldsNameVisibleInDetailPage,
                                                  'listFieldsNameVisibleInJA' : listFieldsNameVisibleInDetailPageJA
                                                  };
            
            this.fetchCandidateRecords();

            this.saveSettingsInCustomMetadataType();
        }
    }
    
    saveSettingsInCustomMetadataType(){
        //ToSettings
        let fieldsetsandfieldsforcard   = this.parametersModalPopupPageSettings.fieldsetsandfieldsforcard; 
        let fieldsetsandfieldsfordetail = this.parametersModalPopupPageSettings.fieldsetsandfieldsfordetail; 
        let fieldsetsandfieldsforja     = this.parametersModalPopupPageSettings.fieldsetsandfieldsforja; 
        
        let nameRecCustomMetadataType = '';
        if (this.userType == 'Interviewer') {
            nameRecCustomMetadataType = 'Settings_of_show_fields_for_Interviewer';
        }
        if (this.userType == 'Recruiter') {
            nameRecCustomMetadataType = 'Settings_of_show_fields_for_Recruiter';
        }        
        if(nameRecCustomMetadataType){
            let labelRecCustomMetadataType = nameRecCustomMetadataType.replaceAll('_',' ');
            let fullNameRecCustomMetadataType = this.settingsNameCustomMetadataTypes + '__mdt.' + nameRecCustomMetadataType;
        
            let settingsStructureForFieldSet = this.makeSettingsFromStructureToSaveInMetadata(fieldsetsandfieldsforcard, fieldsetsandfieldsfordetail, fieldsetsandfieldsforja, this.userType);
            insertAndUpdateCustomMetadata({fullNameMetadata : fullNameRecCustomMetadataType, labelMetadata : labelRecCustomMetadataType, fieldsWithValues : settingsStructureForFieldSet});
        }
    }

    makeSettingsFromStructureToSaveInMetadata(fieldsetsandfieldsforcard, fieldsetsandfieldsfordetail, fieldsetsandfieldsforja, userType){
        const fieldsCustomMetadata = new Map();

        let fieldSetUse = '';
        let fieldsUse = '';
        
        fieldSetUse = '';
        fieldsUse = '';        
        for(const objFieldSet of fieldsetsandfieldsforcard){            
            //FieldSet
            const nameFieldSet = Object.keys(objFieldSet)[0];
            if (objFieldSet[nameFieldSet].used) {
                fieldSetUse = nameFieldSet;                
                //Fields in FieldSet
                for(const objField of objFieldSet[nameFieldSet].fields){
                    const nameField = Object.keys(objField)[0];
                    if(objField[nameField].used) {
                        fieldsUse = fieldsUse + objField[nameField].nameField + ';';
                    }
                }                
            }
        }
        fieldsCustomMetadata.set('Fields_in_FieldSet_for_candidate_card__c', fieldsUse);
        fieldsCustomMetadata.set('FieldSet_for_candidate_card__c', fieldSetUse);

        fieldSetUse = '';
        fieldsUse = '';        
        for(const objFieldSet of fieldsetsandfieldsfordetail){            
            //FieldSet
            const nameFieldSet = Object.keys(objFieldSet)[0];
            if (objFieldSet[nameFieldSet].used) {
                fieldSetUse = nameFieldSet;                
                //Fields in FieldSet
                for(const objField of objFieldSet[nameFieldSet].fields){
                    const nameField = Object.keys(objField)[0];
                    if(objField[nameField].used) {
                        fieldsUse = fieldsUse + objField[nameField].nameField + ';';
                    }
                }                
            }
        }
        fieldsCustomMetadata.set('FieldSet_for_candidate_popup__c', fieldSetUse);
        fieldsCustomMetadata.set('Fields_in_FieldSet_for_candidate_popup__c', fieldsUse);

        fieldSetUse = '';
        fieldsUse = '';        
        for(const objFieldSet of fieldsetsandfieldsforja){            
            //FieldSet
            const nameFieldSet = Object.keys(objFieldSet)[0];
            if (objFieldSet[nameFieldSet].used) {
                fieldSetUse = nameFieldSet;                
                //Fields in FieldSet
                for(const objField of objFieldSet[nameFieldSet].fields){
                    const nameField = Object.keys(objField)[0];
                    if(objField[nameField].used) {
                        fieldsUse = fieldsUse + objField[nameField].nameField + ';';
                    }
                }                
            }
        }
        fieldsCustomMetadata.set('FieldSet_for_JobApp_popup__c', fieldSetUse);
        fieldsCustomMetadata.set('Fields_in_FieldSet_for_JobApp_popup__c', fieldsUse);
                
        fieldsCustomMetadata.set('Setting_for_user_type__c', userType);
        
        return JSON.stringify(Object.fromEntries(fieldsCustomMetadata));
    }

    //Pagination 
    handleSetNewStartRecord(event){        
        this.startRecord = event.detail.startingRecord;  
        this.fetchCandidateRecords();
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