public without sharing class GSOverallCalculationScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ForPeriodCalcSnapshotBatch(false));
        Date currentDate = Date.today();
        List<Date> thursDayList = PROHelper.GetAllThursDayOfMonth(currentDate.year(), currentDate.month());
        List<Date> thursDayListLastMonth = PROHelper.GetAllThursDayOfMonth(currentDate.addMonths(-1).year(), currentDate.addMonths(-1).month());
        List<Date> thursDayListNextMonth = PROHelper.GetAllThursDayOfMonth(currentDate.addMonths(1).year(), currentDate.addMonths(1).month());
        Date startDate;
        Date endDate;
        if (currentDate < thursDayList[1]) {
            startDate = thursDayListLastMonth[3];
            endDate = thursDayList[1];
        } else if (currentDate < thursDayList[3]) {
            startDate = thursDayList[1];
            endDate = thursDayList[3];
        } else {
            startDate = thursDayList[3];
            endDate = thursDayListNextMonth[1];
        }

        if (currentDate == endDate.addDays(-1)) {
            GSOverallCalculationBatch overallBatch = new GSOverallCalculationBatch();
            Database.executeBatch(overallBatch);
        }
    }
}