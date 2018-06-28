public class Supplier {

public static void getAll() {

String allsup = endpoint.callEndPoint('v2','GET','','/Contact/Supplier');
//System.debug(allsup);
Integer alpha = allsup.IndexOf('[');
Integer omega = allsup.lastIndexOf(']')+1;
allsup = allsup.substring(alpha,omega);
//System.debug(allsup);
// Need to replace any JSON keys that are Apex reserved words with a legal substitute
  List<MYOBSupplierV2> r = 
          (List<MYOBSupplierV2>)JSON.deserialize(allsup, List<MYOBSupplierV2>.class);

    for (MYOBSupplierV2 s:r) {
    system.debug(s.CompanyName);
}
}
}
