global class MS_Debug {
    
    global class ActionRequest {
    @InvocableVariable(required=true)
    public String texto;
        
     @InvocableVariable
    public Account acc;
    
        @InvocableVariable
    public Task t;
    }
   

@InvocableMethod(label='MS Debug' description='Escribe en el log.')
    public static void escribe ( List<ActionRequest> requests) {
        for (ActionRequest req: requests) {
	        System.debug('MS APEX DEBUG ('+System.now()+') :'+req.texto);
            if (req.acc!=null) {
                System.debug('MS APEX DEBUG ('+System.now()+') Detalle de la cuenta, ACC_ID: '+req.acc.Id+', Nombre: '+req.acc.Name+', Segmento:' +req.acc.Segmento__c+
                            														', Renovacion proxima:'+req.acc.Fecha_Renovacion_Proxima__c+
                            														', Valoracion: '+req.acc.Customer_Satisfaction_PA__c);
            }
            if (req.t!=null) {
                System.debug('MS APEX DEBUG ('+System.now()+') Detalle de la tarea: '+req.t.Motivo__c+', FEcha Proxima: '+req.t.Fecha_Proxima_Renovacion__c +
                            ', Segmento: '+req.t.segmento__c+', Satisfacion: '+req.t.Customer_Satisfaction_PA__c);  
            }
        }
    }
}