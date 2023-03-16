global class scheduledPositionMassUpdate implements Schedulable {
    global void execute(SchedulableContext sc) {
        PositionMassUpdate batchableMassUpdate = new PositionMassUpdate(); 
        Database.executebatch(batchableMassUpdate);
    }
}