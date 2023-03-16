import { LightningElement, api } from 'lwc';
import { LABELS } from 'c/labelUtility';

export default class customPagination extends LightningElement {
    labelGlobal = LABELS;
    
    @api numberOfRecords;
    startingRecord;
    @api set firstStartingRecord(value) {
        this.startingRecord = value;
    }
    get firstStartingRecord() {return this.startingRecord;};
    endingRecord;
    totalRecordsCount;
    @api set recordsCount(value) {
        if(value){
            this.totalRecordsCount = value;
            this.totalPage = Math.ceil(this.numberOfRecords==0?0:this.totalRecordsCount/this.numberOfRecords);
            this.currentPage = this.currentPage=undefined?1:this.currentPage;
            this.changeNumberCurrentPage(this.currentPage);
        }
    }
    get recordsCount() { return this.totalRecordsCount; }

    currentPage;
    totalPage;
    firstAfterCurrentPage;
    secondAfterCurrentPage;
    yesButtonFirstAfterCurrentPage;
    yesButtonSecondAfterCurrentPage;

    connectedCallback() {
        this.initFields();
    }

    initFields() {
        this.currentPage = 1;
        this.endingRecord = this.numberOfRecords;
        this.totalRecordsCount = this.totalRecordsCount=undefined?0:this.totalRecordsCount;
        this.totalPage = this.totalPage=undefined?0:this.totalPage;
        this.firstAfterCurrentPage = 0;
        this.secondAfterCurrentPage = 0;
        this.yesButtonFirstAfterCurrentPage = false;
        this.yesButtonSecondAfterCurrentPage = false;
    }

    customDispatchEventStartingRecord() {
        this.dispatchEvent(new CustomEvent('newstartrecord', { detail: {startingRecord:this.startingRecord} }));
    }
    
    handleButtonPreviousPage(event) {
        if(this.currentPage > 1){
            this.changeNumberCurrentPage(this.currentPage - 1);
            this.setFieldsPageForRecords(this.currentPage);
            this.customDispatchEventStartingRecord();
        }
    }

    handleButtonFirstPage(event) {
        if(this.currentPage > 1){
            this.changeNumberCurrentPage(1);
            this.setFieldsPageForRecords(this.currentPage);
            this.customDispatchEventStartingRecord();
        }
    }

    handleButtonLastPage(event) {
        if(this.totalPage > 0){
            this.changeNumberCurrentPage(this.totalPage);
            this.setFieldsPageForRecords(this.currentPage);
            this.customDispatchEventStartingRecord();
        }
    }

    handleButtonNextPage(event) {
        if(this.currentPage < this.totalPage){
            this.changeNumberCurrentPage(this.currentPage + 1);
            this.setFieldsPageForRecords(this.currentPage);
            this.customDispatchEventStartingRecord();
        }
    }

    handleButtonGoToCurrentPage(event) {
        this.setFieldsPageForRecords(this.currentPage);
        this.customDispatchEventStartingRecord();
    }

    handleButtonGoToFirstAfterCurrentPage(event) {
        this.changeNumberCurrentPage(this.firstAfterCurrentPage);
        this.setFieldsPageForRecords(this.currentPage);
        this.customDispatchEventStartingRecord();
    }

    handleButtonGoToSecondAfterCurrentPage(event) {
        this.changeNumberCurrentPage(this.secondAfterCurrentPage);
        this.setFieldsPageForRecords(this.currentPage);
        this.customDispatchEventStartingRecord();
    }

    changeNumberCurrentPage(numberPage){
        this.currentPage = numberPage;
        
        if(this.totalPage>=this.currentPage+1){
            this.yesButtonFirstAfterCurrentPage = true;
            this.firstAfterCurrentPage=this.currentPage+1;
        }
        else{
            this.yesButtonFirstAfterCurrentPage = false;
            this.firstAfterCurrentPage=0;
        }
        
        if(this.totalPage>=this.currentPage+2){
            this.yesButtonSecondAfterCurrentPage = true;
            this.secondAfterCurrentPage=this.currentPage+2;
        }
        else{
            this.yesButtonSecondAfterCurrentPage = false;
            this.secondAfterCurrentPage=0;
        }
    }

    setFieldsPageForRecords(pageNumber){
        if(this.numberOfRecords==1) {
            this.startingRecord = pageNumber;
            this.endingRecord = pageNumber;
        }
        else{
            this.startingRecord = (pageNumber-1)*this.numberOfRecords + 1;
            this.startingRecord = (this.startingRecord <= 0) ? 1 : this.startingRecord;
            this.endingRecord = pageNumber*this.numberOfRecords;
            this.endingRecord = (this.endingRecord > this.totalRecordsCount) ? this.totalRecordsCount : this.endingRecord;
        }
    }

}