public with sharing class CloneTriggerHandler 
{
    public static boolean flag=true;
    public static void cloneLead(list<Lead> leadList)
    {
        list<Lead> newLeads=new list<Lead>();
        for(Lead l:leadList)
        {
            Lead l1=l.clone();
            newLeads.add(l1);
        }
        if(flag)
        {
            flag=false;
            insert newLeads;
        }
    }    
}