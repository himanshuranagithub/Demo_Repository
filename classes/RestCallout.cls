public class RestCallout {

    // Define a method to make a dynamic REST call
    public static HttpResponse makeRestCall(String endpoint, String method, Map<String, String> headers, String requestBody) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        
        // Set request headers
        if (headers != null) {
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }
        
        // Set request body
        if (requestBody != null) {
            request.setBody(requestBody);
        }
        
        // Create an HTTP instance and send the request
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        return response;
    }


}