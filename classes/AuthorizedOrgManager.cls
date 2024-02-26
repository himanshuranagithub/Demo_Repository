public class AuthorizedOrgManager {
    
    public static String ENP_POINT_URL = 'https://login.salesforce.com/services/oauth2/token';
    public static String REQUEST_BODY = 'grant_type=password&client_id={0}&client_secret={1}&username={2}&password={3}&security_token={4}';
    public static String USERNAME = 'destination@girikon.com';
    public static String PASSWORD = 'Aglagl@123';
    public static String CONSUMER_KEY = '3MVG9pRzvMkjMb6kClucuezlvOPG3LFCOGV9q3jAUecScKMYq5_3KJ4uk8cxm.llJdjvgEtfexMYyUOkykhZy';
    public static String CONSUMER_SECRET = '69E4B32FA8D1BBE01D52C5A7B3D2C11E99B30EE445836F7D5290B5ADE5A824D9';
    public static String ST = '9NicW9YnSnwoFQurge8qNTsY';
    
    public static String access_token = '';
    public static String instance_url = '';
    
    public static HttpResponse res = new HttpResponse();
    public static HttpRequest req = new HttpRequest();
    public static Http httpObj = new Http();
    
    public static void getAccessToken(){
        try{
            req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod('POST');
            req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,USERNAME,PASSWORD,ST}));
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); // Add Content-Type header
            system.debug('req' + req);
            res = httpObj.send(req);
            system.debug('res' + res.getBody());
            
            Map < String, Object > resultMap = ( Map< String, Object> )JSON.deserializeUntyped( res.getBody() );
            access_token = ( String )resultMap.get( 'access_token' );
            instance_url = ( String )resultMap.get( 'instance_url' );
            
            
        } catch(CalloutException ce) {
            throw ce;
        }
    }
    
    public static void getAccounts() {
        
        getAccessToken();
        
        req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + access_token); // Use the access token from the OAuth response
        req.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        req.setEndpoint(instance_url + '/services/data/v53.0/query/?q=SELECT Id,Name FROM Account');
        req.setMethod('GET');
        system.debug('req' + req);
        res = httpObj.send(req);
        system.debug('res' + res.getbody());
    }
}