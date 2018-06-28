/*
 * Apex controller for the Cursos Calendar, which displays the Calendar in a Salesforce tab.
 * If a course is clicwked on the calendar, page is redirected to the Course record in Salesforce.
 *
 * Created by: Elizabeth Tian, 2016
 *
 */


public class Calendar {
    public String eventsJSON {get; set;}
    public String filterCriteria {get; set;}
    private static String dtFormat = 'EEE, d MMM yyyy HH:mm:ss';
    
    public Calendar() {
        eventsJSON = pageLoad();
    }
    
    @RemoteAction
    public static String pageLoad() {
	    String[] colors = new String[]{'#383838', '#2d5867', '#1e2e4d',
             							'#000d11', '#2c003a',
            							'#cb6464', '#d2b06e', '#7fd472', '#56b9bc', '#645ac1'
            						  };

        List<CalEvent> events = new List<CalEvent>();
        Integer i = 0;
        for (Curso__c cur: [SELECT Name,
                           		   Fecha_de_Inicio__c,
                           		   Fecha_de_Finalizacion__c,
                           		   Frecuencia__c,
                           		   D_as__c,
                            	   Inscriptos__c,
                            	   Limite_de_inscripciones__c,
                                   Tipo_de_Curso__c,
                            	   Dirigido_a__c,
                            	   Importe__c,
                            	   Moneda_Importe__c,
                            	   Responsable__c,
                            	   Comentarios__c
                            FROM Curso__c
                           ]) {
            List<Date> dates = CalculateDates.getDates(cur.Fecha_de_Inicio__c,
                                                       cur.Fecha_de_Finalizacion__c,
                                                       cur.D_as__c,
                                                       cur.Frecuencia__c
                                                      );
            for (Date dat: dates) {
            	CalEvent course = new CalEvent();
                course.title = cur.Name;
                course.allDay = true;
                course.color = colors[i];
                DateTime d = (DateTime) dat;
                course.startString = d.formatGMT(dtFormat);
                course.endString = null;
                course.url = '/' + cur.Id;
                course.className = 'course';
                course.fechaInicio = cur.Fecha_de_Inicio__c;
                course.fechaFinal = cur.Fecha_de_Finalizacion__c;
                course.dias = cur.D_as__c;
                course.frecuencia = cur.Frecuencia__c;
                // optional ones
                course.inscriptos = cur.Inscriptos__c;
                course.limite = cur.Limite_de_inscripciones__c;
                if (cur.Tipo_de_Curso__c != null) {course.tipo = cur.Tipo_de_Curso__c;} else {course.tipo = 'N/A';}
                if (cur.Dirigido_a__c != null) {course.dirigido = cur.Dirigido_a__c;} else {course.dirigido = 'N/A';}
                if (cur.Importe__c != null) {course.importe = cur.Importe__c;} else {course.importe = 0;}
                if (cur.Moneda_Importe__c != null) {course.moneda = cur.Moneda_Importe__c;} else {course.moneda = 'N/A';}
                if (cur.Responsable__c != null) {course.responsable = cur.Responsable__c;} else {course.responsable = 'N/A';}
                if (cur.Comentarios__c != null) { course.comentarios = cur.Comentarios__c;} else {course.comentarios = 'None';}
                events.add(course);
            }
            if (i < colors.size() - 1) {
                i++;
            } else {
                i = 0;
            }                       
        }
        String jsonEvents = JSON.serialize(events);
        jsonEvents = jsonEvents.replace('startString','start');
        jsonEvents = jsonEvents.replace('endString','end');
        return jsonEvents;
    }
    
    public class CalEvent {
        public String title {get; set;}
        public String color {get; set;}
        public Boolean allDay {get; set;}
        public String startString {get; set;}
        public String endString {get; set;}
        public String url {get; set;}
        public String className {get; set;}
        public Decimal inscriptos {get; set;}
        public Date fechaInicio {get; set;}
        public Date fechaFinal {get; set;}
        public String dias {get; set;}
        public String frecuencia {get; set;}
        public Decimal limite {get; set;}
        public String tipo {get; set;}
        public String dirigido {get; set;}
        public Decimal importe {get; set;}
        public String moneda {get; set;}
        public String responsable {get; set;}
        public String comentarios {get; set;}
    }

}