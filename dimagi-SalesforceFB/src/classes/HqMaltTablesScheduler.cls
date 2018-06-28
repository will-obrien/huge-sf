/**
 * HqMaltTablesScheduler schedules Malt tables calculations
 */
public class HqMaltTablesScheduler implements Schedulable {

    // we need run this job on 3 each month!!!
    public void execute(SchedulableContext sc) {
        Date current = Date.today().addMonths(-1).toStartOfMonth();
        List<String> servers = HqBatchJobHelper.getCommcareServers(false);
        if (servers.size() > 0 && current != null) {
            String serverCode = servers.get(0);
            servers.remove(0);
            Database.executeBatch(new HqMaltTablesBatch(serverCode, servers, current, true), 1);
        }
    }
}