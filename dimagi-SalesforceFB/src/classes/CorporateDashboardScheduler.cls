public class CorporateDashboardScheduler implements Schedulable {

    public CorporateDashboardScheduler () {}

    public void execute(SchedulableContext sc) {
       CorporateDashboardHelper.refreshAllGraphsFuture();
    }
}