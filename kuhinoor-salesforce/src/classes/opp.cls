public class opp
{
public id oppid{set;get;}
id s;
set<id> opset=new set<id>();
public boolean check{set;get;}
public boolean oppview{set;get;}
public boolean oppeditview{set;get;}
opportunity oo=new opportunity();
list<Opportunity > oplist=new list<Opportunity  >();
list<OpportunityLineItem > olist=new list<OpportunityLineItem >();
list<product2> plist=new list<product2>();
public class wrapperopp
{
public boolean check1{set;get;}
public boolean oppview{set;get;}
public string name{set;get;}
public string description{set;get;}
public string prodfamily{set;get;}
public string prodcode{set;get;}
public decimal standardprice{set;get;}
public id pid{set;get;}
public boolean oppeditview{set;get;}
}
list<wrapperopp> wlist=new list<wrapperopp>();
/*public void prodetails()
{

for(product2 p:[select id,name from product2 ])
{
wrapperopp op=new wrapperopp();
op.name=p.name;
if(opset.contains(p.id))
op.check1=true;
else
op.check1=false;
wlist.add(op);
}
}*/

set<id> oset=new set<id>();
list<wrapperopp> wrlist=new list<wrapperopp>();
opportunitylineitem ol=new opportunitylineitem ();
public opp()
{
oppeditview=false;
oppview=true;
details();
}
public void details()
{
for(Opportunity o:[select id,name from Opportunity])
{
oplist.add(o);
}
}

public list<Opportunity> getopprecs()
{
return oplist;
}
set<id> oset1=new set<id>();
list<opportunity> olist1=new list<opportunity>();
public void viewdetail()
{

oppeditview=true;
oppview=false;
s=apexpages.currentpage().getparameters().get('vid');
oo=[select name,accountid,type,leadsource,stagename,probability,amount,closedate,nextstep,description from opportunity where id =:s];
oppid=oo.id;
 for(OpportunityLineItem o:[select PricebookEntryId from OpportunityLineItem where opportunityid=:s])
 {
 oset1.add(o.pricebookEntryId);
 }
 for(pricebook2 o:[select id from pricebook2 where isactive=:true  ])
      {
      oset.add(o.id);
      }
      for(pricebookEntry p:[select id,name,product2.productcode,productcode,product2.Family,product2.description,UnitPrice  from pricebookentry where pricebook2id in :oset and isactive=:true ])
      {
      wrapperopp w=new wrapperopp();
      w.pid=p.id;
      w.name=p.name;
      w.check1=false;
      w.description=p.product2.description;
      w.prodfamily=p.product2.Family;
      w.prodcode=p.productcode;
      w.standardprice=p.UnitPrice;
      wlist.add(w);
      if(oset1.contains(w.pid))
      {
      w.check1=true;
      }
      }
      }
     
public opportunity geteditopp()
{
return oo;
}
public list<wrapperopp> getprod()
{
return wlist;
}

list<opportunitylineitem> optlist=new list<opportunitylineitem>();
public void save()
{
wrapperopp wo=new wrapperopp();
update oo;
for(opportunity o:[select id from opportunity where id=:oppid])
{
for(wrapperopp w2:wlist)
{
if(!oset1.contains(w2.pid))
if(w2.check1==true)
{
opportunitylineitem oi=new opportunitylineitem();
oi.PricebookEntryId=w2.pid;
oi.quantity=2;
oi.opportunityid=o.id;
oi.TotalPrice=120;
optlist.add(oi);
}
}
}

upsert optlist;
}

public void cancel()
{
oppeditview=false;
oppview=true;
}

}