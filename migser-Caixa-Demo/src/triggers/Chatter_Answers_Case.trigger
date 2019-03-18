//adds entitlement to case when a case is created in chatter answers, which in turn adds milestones and timeline

trigger Chatter_Answers_Case on Case (before update) {
    for (Case c: Trigger.new) {
       
        if(c.Origin == 'Chatter Answers'){
            Entitlement e = new Entitlement();
            e = [SELECT id FROM Entitlement WHERE Name = 'Premium Phone Support'];
            c.EntitlementId = e.Id;
       }
    }
}