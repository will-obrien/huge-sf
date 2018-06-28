public class CalloutStaticClass {
    public static HttpResponse getInfoFromExternalService(String endpoint){
        HttpRequest req = new HttpRequest();	// creem una nova solicitud http //
        req.setEndpoint(endpoint); // establim l'endpoint passat com argument //
        req.setMethod('GET'); // establim el metode get //
        Http h = new Http(); // creem un objecte de la classe http, per iniciar un http request and response //
        HttpResponse res = h.send(req); // enviem la request i la guardem al response //
        return res; // retornem la resposta //
    }
}
