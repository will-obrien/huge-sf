/*
 * Apex class used by AnadirAsistencia trigger to calculate the specific dates
 * for Attendance records to be automatically created for a Registration record,
 * based on the start date, end date, the day of the week, and the frequency of
 * the course that the contact is registering for.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/

public class CalculateDates {
	public static Date[] getDates(Date initial, Date finalDate, String dayWeek, String frequency) {
		String[] days = dayWeek.split(';');
		Map<String, Integer> freqMap = new Map<String, Integer>{
            'Semanalmente' => 7,
            'Quincenalmente' => 14,
            'Mensualmente' => 28
            };
		Map<String, Integer> dayMap = new Map<String, Integer>{
			'Lunes' => 1,
			'Martes' => 2,
			'Miercoles' => 3,
			'Jueves' => 4,
			'Viernes' => 5,
			'Sabado' => 6,
			'Domingo' => 7
			};

		Date[] dates = new List<Date>();

		// Start day will be 1 = Mon, 2 = Tues, etc
		DateTime start = (DateTime) initial;
		start = start.addHours(start.hour());
		start = start.addMinutes(start.minute());
		start = start.addSeconds(start.second());
        
		Integer startDay = Integer.valueOf(start.format('u'));

		for (String day: days) {
			Integer calculated = dayMap.get(day) - startDay + 7;
            // System.debug(calculated);
			Date firstDate = initial + Math.mod(calculated, 7);
			if (firstDate > finalDate) continue;
			
			// get which week of the month
			Integer weekOfMonth = Math.ceil((Double)(firstDate.Day()) / 7).intValue();

			Date currDate = firstDate;
			while(currDate <= finalDate) {
				
				if (frequency == 'Mensualmente') {
					currDate = currDate.toStartOfMonth();
					DateTime startD = (DateTime) currDate;
					startD = startD.addHours(startD.hour());
					startD = startD.addMinutes(startD.minute());
					startD = startD.addSeconds(startD.second());
					Integer begDay = Integer.valueOf(startD.format('u'));
					Integer calc = dayMap.get(day) - begDay + 7;
					currDate = currDate + Math.mod(calc, 7);

					// whichever week it is
					currDate = currDate.addDays(7*(weekOfMonth - 1));
					
					dates.add(currDate);
					currDate = currDate.addMonths(1);
				}
				else {
					dates.add(currDate);
					currDate += freqMap.get(frequency);
				}
			}
		}

		return dates;
	}
}