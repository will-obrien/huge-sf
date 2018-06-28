public with sharing class Milestone1_Move_Exception extends Exception{
    
    public static final String ERROR_MILESTONE_ALREADY_ASSIGNED_PROJECT = 'A milestone you are attempting to move is already assigned to this project. Please review your selection and try again.';
    public static final String ERROR_TASK_ALREADY_ASSIGNED_MILESTONE = 'A task you are attempting to move is already assigned to this milestone. Please review your selection and try again.';
    public static final String ERROR_MILESTONE_COMPLETE = 'Milestone is Complete, the Task can not be moved';
    
    static testMethod void testConstants() 
    {
        //Just a place holder test method for static constants on this exception class.
        system.assert(true);
    }

}