# Cursos-Salesforce-App

* Salesforce package with Course, Registration, and Attendance Objects
* Uses Apex, Visualforce, SOQL, jQuery, CSS
* Automatically creates Attendance records when Contact is registered for a course
* Buttons allow for multiple registrations
* Calendar displays courses, when clicked directs to course page, on hover displays course information
* Includes web integration that allows guests to sign up from the calendar and stores their information into database if their email does not exist already (using SOQL query); subscribes the newly created or previously existing Contact to the course (with a new Registration record
and the automatically created Attendance records)

This app can be found and downloaded for free into your Salesforce environment through Salesforce Appexchange. The manual can also be downloaded here.

####Relevant Files:

Classes: 
  * Calendar.cls
  * Calendar_Website.cls
  * Signup.cls
  * Add_Multiple_Subscriptions_Contact.cls
  * Add_Multiple_Subscriptions_Course.cls
  * CalculateDates.cls
  * TestCalendar.cls
  * TestCalendar_Website.cls
  * TestSignup.cls
  * TestAddMultipleSubscriptionsContact.cls
  * TestAddMultipleSubscriptionsCourse.cls
  * TestCalculateDates.cls
  * TestAnadirAsistencia.cls

Triggers:
  * AnadirAsistencia.trigger

Pages:
  * Calendar.page
  * Calendar_Website.page
  * Signup.page
  * Add_Multiple_Subscriptions_Contact.page
  * Add_Multiple_Subscriptions_Course.page

Sample of functionality:
---

####Tabs:
* Course object
* Registration object
* Attendance Object
* Course Calendar

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Tabs.png" width="35%" height="35%" />

####Course Calendar page:
* Allows for web integration
* Filter by course name
* Description on hover
* Signup page on click
* Different color for each course

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Calendar.png" width="85%" height="85%" />

####Signup page:
* Course info displayed
* New Registration record to the course stored in Salesforce database, along with automatically created Attendance records
* Automatic confirmation email sent to attendant
* If "Asistente Nuevo" is selected, a new Contact is created and linked to this registration if contact does not already exist
* If "Asistente Viejo" is selected, the registration is linked to a previous contact in the Salesforce database found through an SOQL query using email match

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Signup_Demo.png" width="85%" height="85%" />

####Course object:
* Requires start date, end date, frequency (weekly, biweekly, month), days of the week (e.g. MWF)
* Related list of registrations and attendances
* "Multiples Registrations" button

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Course.png" width="55%" height="55%" />

####Multiple Registration button:
* SOQL query pulls up a list of all Contacts in the database
* Allows multiple Contacts to register for this course, creating new Registration and Attendance objects correspondingly
* Another button on Contact page allows a contact to register for multiple Courses, creating new Registration and Attendance objects correspondingly

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Multiples.png" width="55%" height="55%" />

####Registration object:
* Connected to a Contact and a Course

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Registration.png" width="55%" height="55%" />

####Attendance List View:
* Attendance records are created automatically when a Registration record is created for a course, corresponding to the exact dates that the contact will attend
* A course instructor can then select who has attended their course for a particular day

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Attendance.png" width="85%" height="85%" />

####Attendance object

<img src="https://raw.github.com/elizabethtian/Cursos-Salesforce-App/master/img/Att.png" width="55%" height="55%" />
