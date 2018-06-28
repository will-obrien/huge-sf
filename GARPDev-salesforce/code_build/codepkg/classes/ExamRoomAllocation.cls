public class ExamRoomAllocation{
    //Controller
    public Boolean disableButton {set; get;}
    public ExamRoomAllocation() {
        //disableButton = false;
    }
    //method called from Command Button on Vf page, invokes Batch process for Account Group Records.
    public void initiateRoomAllocation() {
        //disableButton = true;
        String groupID = ApexPages.currentPage().getParameters().get('gid');
        AssignRoomsToExamAttempts roomBatch = new AssignRoomsToExamAttempts();
        roomBatch.query = 'SELECT Id,disableMoveLogic__c,Rooms_Assigned__c FROM Exam_Group__c  where Id= \''+ groupID+'\'' ;
        Database.executeBatch(roomBatch); //invoke Batch
    }    
}