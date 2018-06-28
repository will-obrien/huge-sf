global class BatchCalculateTotalHoursBtn {

    webservice static void executeBatch(String contractId) { 
        Database.executeBatch(new BatchCalculateTotalHoursOfTimeCard(contractId));
    }
}