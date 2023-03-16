import { LightningElement, wire, api } from 'lwc';

import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi'; 
import LightningConfirm     from 'lightning/confirm';
import { ShowToastEvent }   from 'lightning/platformShowToastEvent';

import getPositionsRecords       from '@salesforce/apex/PositionControllerLWS.getPositionsRecords';
import updataPositionsList       from '@salesforce/apex/PositionControllerLWS.updataPositionsList';

import POSITION_OBJECT      from '@salesforce/schema/Position__c';
import NAME_FIELD           from '@salesforce/schema/Position__c.Name';
import STATUS_FIELD         from '@salesforce/schema/Position__c.Status__c';
import OPENDATE_FIELD       from '@salesforce/schema/Position__c.Open_Date__c';
import CLOSEDATE_FIELD      from '@salesforce/schema/Position__c.Close_Date__c';

import { LABELS } from 'c/labelUtility';

const DEFAULT_STATUS_FILTER = 'All';
const COLUMNS = [
    {
        label: LABELS.NAME_LABEL,
        fieldName: 'nameURL',
        editable: false,
        type: 'url',
        typeAttributes: {label: { fieldName: NAME_FIELD.fieldApiName }, target: '_blank'}
    },
    {
        label: LABELS.STATUS_LABEL,
        fieldName: STATUS_FIELD.fieldApiName,
        editable: false,
        type: 'statusPicklist',
        typeAttributes:
           {
            label: LABELS.STATUS_LABEL,
            //***Variant with combobox component
            //variant: 'label-hidden',            
            //placeholder: 'Choose Status',
            options: {fieldName: 'picklistOption'},
            value: {fieldName: STATUS_FIELD.fieldApiName},
            id: {fieldName: 'Id'}
           },
        wrapText: true
    },
    {   label: LABELS.OPEN_DATE_LABEL, 
        fieldName: OPENDATE_FIELD.fieldApiName, 
        editable: false,
        type: 'date'
    },
    {   label: LABELS.CLOSE_DATE_LABEL, 
        fieldName: CLOSEDATE_FIELD.fieldApiName, 
        editable: false,
        type: 'date'
    }
];

export default class positionStatus extends LightningElement {
    labelGlobal = LABELS;

    columnsPositions = COLUMNS;
    positions = [];
    needToSaveData = [];

    picklistOptionStatus = [];
    statusListForTable = [];
    statusListFilter = [];
    defaultStatusFilterTextValue = DEFAULT_STATUS_FILTER;
    selectedStatusFilterTextValue = this.defaultStatusFilterTextValue;
    
    //Pagination
    @api numberOfRecordsInPage;
    startRecord = 1;
    totalRecords = 0;

    @wire(getObjectInfo, {objectApiName: POSITION_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {fieldApiName: STATUS_FIELD, recordTypeId: '$objectInfo.data.defaultRecordTypeId'})
    wiredGetPicklistValues({error,data}) {
        if (data) {
            this.picklistOptionStatus = data.values;
            this.genStatusLists();
            this.addToPositionsTablePicklistOptionStatus();
        }
        else if (error) {
            console.error(error);
        }
    }

    genStatusLists() {
        this.statusListFilter = [...this.picklistOptionStatus];
        this.statusListFilter.unshift({label:this.defaultStatusFilterTextValue, value:this.defaultStatusFilterTextValue}); 

        this.statusListForTable = [...this.picklistOptionStatus];
        this.statusListForTable.unshift({label:'...', value:''}); 
    }

    connectedCallback() {
        this.selectedStatusFilterTextValue = this.defaultStatusFilterTextValue;
        this.positions.length = 0;
        this.needToSaveData.length = 0;
        this.fetchPositions();
    }

    fetchPositions() {
        getPositionsRecords({filterStatus : this.selectedStatusFilterTextValue, 
                                startFromRecord : this.startRecord, 
                                        quantityRecords: this.numberOfRecordsInPage})
                .then((result)=>{
                    //Pagination
                    this.totalRecords = result.countRecords;                                                                          
                    this.positions = [...result.listRecords];
                    this.addToPositionsTablePicklistOptionStatus();
                })
                .catch((error)=>{
                    this.positions = [];
                    console.error(error);
                    this.showErrorToast(LABELS.ERROR_LABEL + ' ' + LABELS.GET_LABEL + ' ' + LABELS.THE_LABEL.toLowerCase() + ' ' + LABELS.DATA_LABEL.toLowerCase()+'!',error.body.message);
                })
    }

    addToPositionsTablePicklistOptionStatus(){
        if((this.statusListForTable) && (this.positions.length!=0)) {
            this.positions = this.positions.map((record)=>{
                return {
                        ...record, 
                        'picklistOption': this.statusListForTable.map((option)=>{
                                        return {
                                                ...option, 
                                                selected: ((option.value=='...')||(option.value==''))? '' : option.value===record.Status__c,
                                                }
                                        }
                                    )
                        ,
                        'nameURL': '/'+Object.assign({},record).Id
                        }                    
            });
        }
    }

    handleStatusFilterChange(event){
        //Pagination 
        this.startRecord = 1;
        this.recordsCount = this.totalRecords;

        this.selectedStatusFilterTextValue = event.detail.value;        
        this.fetchPositions();
    }

    handleStatusChangeInTable(event) {
        this.addToArraySavedData(event.detail.id, event.detail.value, this.needToSaveData);
    }

    addToArraySavedData(detailId, detailValueStatus, ArraySavedData) {
        const NORM_ID = this.cutExtraChar(detailId,'-');
        let indexArraySavedData = this.searchIdIndexElemInArraySavedData(NORM_ID, ArraySavedData);
        if(indexArraySavedData === -1) 
            ArraySavedData.push({Id: NORM_ID, Status__c: detailValueStatus});
        else
            ArraySavedData[indexArraySavedData].Status__c = detailValueStatus;
    }
    searchIdIndexElemInArraySavedData(elemId, ArraySavedData) {
        let indexArraySavedData = -1;
        for (let i = 0; i < ArraySavedData.length; i++) {
            if (ArraySavedData[i].Id === elemId) {
                indexArraySavedData = i;
            }
        }
        return indexArraySavedData;
    }
    cutExtraChar(infoText,searchText) {
        let newInfoText = infoText;
        newInfoText = newInfoText.slice(0, newInfoText.indexOf(searchText));
        return newInfoText;
    }

    //Pagination 
    handleSetNewStartRecord(event){
        this.startRecord = event.detail.startingRecord;  
        this.fetchPositions();
    }

    onSave(event) {
        if(this.needToSaveData.length==0) return;
        const RESULT_CONFIRM = LightningConfirm.open({
            message:    LABELS.WANT_TO_CONTINUE_LABEL,
            variant:    'header',
            label:      LABELS.PLEASE_LABEL + ' ' + LABELS.CONFIRM_LABEL,
            theme:      'shade',
        });
        RESULT_CONFIRM
            .then((resultAnswer)=>{
                if(resultAnswer) {
                    updataPositionsList({dataUpdate : this.needToSaveData})
                        .then((result) => {
                            this.rezultUpDate = result;
                            if(this.rezultUpDate==true)
                                this.needToSaveData.length = 0;
                            else{
                                let textMsgErrorupdata = LABELS.SAVE_LABEL + ' ' + LABELS.STATUS_LABEL.toLowerCase() + ' ' + LABELS.OF_LABEL + ' ' + LABELS.POSITION_LABEL.toLowerCase() + ' ' + LABELS.FAILED_LABEL + '!';
                                console.error(textMsgErrorupdata);
                                this.showErrorToast(textMsgErrorupdata,LABELS.ERROR_LABEL);
                            }
                        })
                        .catch((error)=>{ 
                            console.error(error);
                            this.showErrorToast(LABELS.ERROR_LABEL + ' ' + LABELS.UPDATA_LABEL.toLowerCase() + '!',error.body.message);
                        });
                }
            })
            .catch((error)=>{ 
                console.error(error);
                this.showErrorToast(LABELS.SAVE_LABEL + ' ' + LABELS.THE_LABEL.toLowerCase() + ' ' + LABELS.PROBLEM_LABEL.toLowerCase() + '!');
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