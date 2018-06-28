/*
 * Apex test class for Calculate Dates 
 *
 * CalculateDates class is used by AnadirAsistencia trigger to calculate the specific dates
 * for Attendance records to be automatically created for a Registration record,
 * based on the start date, end date, the day of the week, and the frequency of
 * the course that the contact is registering for.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/

@isTest
public class TestCalculateDates {
    @isTest static void testGetDates() {
        Date initial = Date.newInstance(2016, 1, 1);
        Date finalDate = Date.newInstance(2016, 1, 31);
        String dayWeek = 'Lunes;Viernes';
        String freq = 'Semanalmente';
        Date[] testing = CalculateDates.getDates(initial, finalDate, dayWeek, freq);
        testing.sort();     
        System.assert(testing.size() == 9);
        System.assertEquals(Date.newInstance(2016, 1, 1), testing[0]);
        System.assertEquals(Date.newInstance(2016, 1, 4), testing[1]);
        System.assertEquals(Date.newInstance(2016, 1, 8), testing[2]);
        System.assertEquals(Date.newInstance(2016, 1, 11), testing[3]);
        System.assertEquals(Date.newInstance(2016, 1, 15), testing[4]);
        System.assertEquals(Date.newInstance(2016, 1, 18), testing[5]);
        System.assertEquals(Date.newInstance(2016, 1, 22), testing[6]);
        System.assertEquals(Date.newInstance(2016, 1, 25), testing[7]);
        System.assertEquals(Date.newInstance(2016, 1, 29), testing[8]);
        
        Date monthInitial = Date.newInstance(2016, 1, 1);
        Date monthFinal = Date.newInstance(2016, 12, 10);
        String dayWeek2 = 'Miercoles';
        String freq2 = 'Mensualmente';
        Date[] test2 = CalculateDates.getDates(monthInitial, monthFinal, dayWeek2, freq2);
        System.assert(test2.size() == 12);
        System.assertEquals(Date.newInstance(2016, 1, 6), test2[0]);
        System.assertEquals(Date.newInstance(2016, 2, 3), test2[1]);
        System.assertEquals(Date.newInstance(2016, 3, 2), test2[2]);
        System.assertEquals(Date.newInstance(2016, 4, 6), test2[3]);
        System.assertEquals(Date.newInstance(2016, 5, 4), test2[4]);
        System.assertEquals(Date.newInstance(2016, 6, 1), test2[5]);
        System.assertEquals(Date.newInstance(2016, 7, 6), test2[6]);
        System.assertEquals(Date.newInstance(2016, 8, 3), test2[7]);
        System.assertEquals(Date.newInstance(2016, 9, 7), test2[8]);
        System.assertEquals(Date.newInstance(2016, 10, 5), test2[9]);
        System.assertEquals(Date.newInstance(2016, 11, 2), test2[10]);
        System.assertEquals(Date.newInstance(2016, 12, 7), test2[11]);

    }
}