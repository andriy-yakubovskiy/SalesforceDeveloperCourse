public with sharing class PositionFunctionExpression {
    
    private String makeTextQueryForPosition(String filterStatus) {
        String textQuery = '';

        List<String> listNameFieldsPosition = new List<String>();
        listNameFieldsPosition.add('Status__c');
        listNameFieldsPosition.add('Open_Date__c');
        listNameFieldsPosition.add('Close_Date__c');
        
        String notAccessibleFields = '';
        GeneralFunctionsMethods.AccessPropertiesForObject accessObject = GeneralFunctionsMethods.getAccessPropertiesToObject('Position__c');
        for (String nameField : listNameFieldsPosition) {
            DescribeFieldResult fieldObjectMetadata = accessObject.fieldsDescribeMetadata.get(nameField);
            if(!fieldObjectMetadata.isAccessible()) {
                notAccessibleFields = notAccessibleFields + (String.isEmpty(notAccessibleFields)? '' : ', ') + fieldObjectMetadata.getLabel();
            }
        }
        if((accessObject.isAccessible) && (String.isEmpty(notAccessibleFields))) {
            Integer MaxRecords = GeneralFunctionsMethods.returnMaxRecordsAsPerLimit();
            //String textQuery = 'SELECT ID,Name,Status__c,Open_Date__c,Close_Date__c FROM Position__c';
            String queryFields = 'Id,Name';
            for (String nameField : listNameFieldsPosition) {                        
                queryFields = queryFields + ',' + nameField;
            }
            textQuery = GeneralFunctionsMethods.createQueryTextForPosition(queryFields,filterStatus);
            textQuery = textQuery + ' LIMIT '+String.valueOf(MaxRecords);    
        }

        return  textQuery;
    }

    public List<Position__c> Positions {
        get{
            return getPositions();
        }
        set;
    }
    
    public Position__c oPos {
        get{
            //try {
                if (oPos == null) {
                    oPos = new Position__c();    
                }
                return oPos;
            // } catch (Exception ex) {
            //     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
            //     ApexPages.addMessage(msg);
            //     return null;
            // }
        }
        set;
    }
    public ApexPages.StandardSetController setControllerPositions {
        get {            
            if(setControllerPositions == null) {
                //try {
                    String queryText = makeTextQueryForPosition('');
                    if (!String.isBlank(queryText)) 
                        setControllerPositions = new ApexPages.StandardSetController(Database.getQueryLocator(queryText));                    
                    else 
                        return null;    
                // } catch (Exception ex) {
                //     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
                //     ApexPages.addMessage(msg);
                //     return null;
                // }
            }
            return setControllerPositions;
        }
        set;
    }

    public List<Position__c> getPositions() {
        if(setControllerPositions != null) 
            return (List<Position__c>) setControllerPositions.getRecords();
        else 
            return (null);
    }

    //public PageReference doSearch() {
    public void doSearch() {
        if(setControllerPositions != null) {
            String filterStatus = '';        
            if (oPos != null) {
                filterStatus = oPos.Status__c;
            }
            //try {
                String queryText = makeTextQueryForPosition(filterStatus);
                if (!String.isBlank(queryText)) 
                    setControllerPositions = new ApexPages.StandardSetController(Database.getQueryLocator(queryText));                    
                else 
                return;
                //return null;                
            // } catch (Exception ex) {
            //     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
            //     ApexPages.addMessage(msg);    
            // }            
        }
        return;
        //return null;
    }
    //public PageReference save() {
    public void save() {
        try {
            setControllerPositions.save();
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return;
        //return null;
	}

    public void first() { setControllerPositions.first(); }
    public void last() { setControllerPositions.last(); }
    public void previous() { setControllerPositions.previous(); }
    public void next() { setControllerPositions.next(); }
    public Boolean hasPrevious {
		get { return setControllerPositions.getHasPrevious(); }
		set;
	}
    public Boolean hasNext {
		get { return setControllerPositions.getHasNext(); }
		set;
	}
}