import JOB_APPLICATIONS_LABEL from '@salesforce/label/c.Job_applications';
import POSITIONS_LABEL from '@salesforce/label/c.Positions';
import CANDIDATE_LABEL from '@salesforce/label/c.Candidate';
import JOB_APPLICATION_LABEL from '@salesforce/label/c.Job_application';
import POSITION_LABEL from '@salesforce/label/c.Position';
import NAME_LABEL from '@salesforce/label/c.Name';
import STATUS_LABEL from '@salesforce/label/c.Status';
import CLOSE_DATE_LABEL from '@salesforce/label/c.Close_date';
import OPEN_DATE_LABEL from '@salesforce/label/c.Open_date';
import FIRST_LABEL from '@salesforce/label/c.First';
import PREVIOUS_LABEL from '@salesforce/label/c.Previous';
import NEXT_LABEL from '@salesforce/label/c.Next';
import LAST_LABEL from '@salesforce/label/c.Last';
import LINK_LABEL from '@salesforce/label/c.Link';
import FILTER_LABEL from '@salesforce/label/c.filter';
import SELECT_LABEL from '@salesforce/label/c.Select';
import SEARCH_LABEL from '@salesforce/label/c.Search';
import SAVE_LABEL from '@salesforce/label/c.Save';
import CANCEL_LABEL from '@salesforce/label/c.Cancel';
import LIST_DATA_IS_EMPTY_LABEL from '@salesforce/label/c.List_data_is_empty';
import RECORDS_LABEL from '@salesforce/label/c.Records';
import TO_LABEL from '@salesforce/label/c.to';
import OF_LABEL from '@salesforce/label/c.of';
import THE_LABEL from '@salesforce/label/c.The';
import ERROR_LABEL from '@salesforce/label/c.Error';
import GET_LABEL from '@salesforce/label/c.get';
import FOR_LABEL from '@salesforce/label/c.for';
import DATA_LABEL from '@salesforce/label/c.Data';
import PLEASE_LABEL from '@salesforce/label/c.Please';
import CONFIRM_LABEL from '@salesforce/label/c.confirm';
import WANT_TO_CONTINUE_LABEL from '@salesforce/label/c.Want_to_continue';
import NEW_CANDIDATE_JOB_APPLICATION from '@salesforce/label/c.New_Candidate_JobApplication';
import FAILED_LABEL from '@salesforce/label/c.failed';
import UPDATA_LABEL from '@salesforce/label/c.Updata';
import PROBLEM_LABEL from '@salesforce/label/c.Problem';
import FIELD_LABEL from '@salesforce/label/c.field';
import ACCESS_DENIED_LABEL from '@salesforce/label/c.Access_denied';

const LABELS = {
        JOB_APPLICATIONS_LABEL : JOB_APPLICATIONS_LABEL,
        JOB_APPLICATION_LABEL : JOB_APPLICATION_LABEL,
        CANDIDATE_LABEL : CANDIDATE_LABEL,
        POSITIONS_LABEL : POSITIONS_LABEL,
        POSITION_LABEL : POSITION_LABEL,
        NAME_LABEL : NAME_LABEL,
        STATUS_LABEL : STATUS_LABEL,
        CLOSE_DATE_LABEL : CLOSE_DATE_LABEL,
        OPEN_DATE_LABEL : OPEN_DATE_LABEL,
        FIRST_LABEL : FIRST_LABEL,
        PREVIOUS_LABEL : PREVIOUS_LABEL,
        NEXT_LABEL : NEXT_LABEL,
        LAST_LABEL : LAST_LABEL,
        LINK_LABEL : LINK_LABEL,
        FILTER_LABEL : FILTER_LABEL,
        SELECT_LABEL : SELECT_LABEL,
        SEARCH_LABEL : SEARCH_LABEL,
        SAVE_LABEL : SAVE_LABEL,
        CANCEL_LABEL : CANCEL_LABEL,
        SELECT_STATUS_LABEL : SELECT_LABEL + ' ' + STATUS_LABEL.toLowerCase(),
        STATUS_FILTER_LABEL : STATUS_LABEL + ' ('+FILTER_LABEL+')',
        LIST_DATA_IS_EMPTY_LABEL : LIST_DATA_IS_EMPTY_LABEL,
        RECORDS_LABEL : RECORDS_LABEL,
        TO_LABEL : TO_LABEL,
        OF_LABEL : OF_LABEL,
        THE_LABEL : THE_LABEL,
        ERROR_LABEL : ERROR_LABEL,
        GET_LABEL : GET_LABEL,
        FOR_LABEL : FOR_LABEL,
        DATA_LABEL : DATA_LABEL,
        PLEASE_LABEL : PLEASE_LABEL,
        CONFIRM_LABEL : CONFIRM_LABEL,
        WANT_TO_CONTINUE_LABEL : WANT_TO_CONTINUE_LABEL,
        NEW_CANDIDATE_JOB_APPLICATION : NEW_CANDIDATE_JOB_APPLICATION,
        FAILED_LABEL : FAILED_LABEL,
        UPDATA_LABEL : UPDATA_LABEL,
        PROBLEM_LABEL : PROBLEM_LABEL,        
        FIELD_LABEL : FIELD_LABEL,
        ACCESS_DENIED_LABEL : ACCESS_DENIED_LABEL
}

export {LABELS};