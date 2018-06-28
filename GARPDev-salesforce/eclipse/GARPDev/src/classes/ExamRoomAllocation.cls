public class ExamRoomAllocation{
    //Controller
    public Boolean disableButton {set; get;}
    public ExamRoomAllocation() {
        disableButton = false;
    }
    //method called from Command Button on Vf page, invokes Batch process for Account Group Records.
    public void initiateROomAllocation() {
        disableButton = true;
        AssignRoomsToExamAttempts roomBatch = new AssignRoomsToExamAttempts();
        Database.executeBatch(roomBatch); //invoke Batch
    }    
}