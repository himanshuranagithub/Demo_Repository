public class SalesforceAuth {
    
    public static String PRODUCTION = 'https://login.salesforce.com/services/oauth2/token?';
    public static String SANDBOX = 'https://test.salesforce.com/services/oauth2/token';
    public static String CALLBACK_URL = 'https://girikon177-dev-ed--c.develop.vf.force.com/apex/Auth';
    public static String REQUEST_BODY = 'grant_type=password&client_id={0}&client_secret={1}&username={2}&password={3}&security_token={4}';
    //public static String USERNAME = 'destination@girikon.com';
    //public static String PASSWORD = 'Aglagl@123';
    public static String CONSUMER_KEY = '3MVG9pRzvMkjMb6kClucuezlvOPG3LFCOGV9q3jAUecScKMYq5_3KJ4uk8cxm.llJdjvgEtfexMYyUOkykhZy';
    public static String CONSUMER_SECRET = '69E4B32FA8D1BBE01D52C5A7B3D2C11E99B30EE445836F7D5290B5ADE5A824D9';
    //public static String ST = '9NicW9YnSnwoFQurge8qNTsY';
    
    public static String access_token = '';
    public static String instance_url = '';
    
    public static HttpResponse response = new HttpResponse();
    public static HttpRequest req = new HttpRequest();
    public static Http http = new Http();
    
    public static void getAccessToken(){
        String encodedCode = ApexPages.currentPage().getParameters().get('code');
        String code  = EncodingUtil.urlDecode(encodedCode, 'UTF-8');
        String REQUEST_BODY = PRODUCTION+'grant_type=authorization_code&code='+code+'&client_id='+CONSUMER_KEY+'&client_secret='+CONSUMER_SECRET+'&redirect_uri='+CALLBACK_URL;
        system.debug('REQUEST_BODY'+REQUEST_BODY);
        req.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        req.setEndpoint(REQUEST_BODY);
        req.setMethod( 'POST');
        
        response = http.send( req );
        
        System.debug( 'Response Body is ' + response.getBody());
        
        if(response.getStatusCode() == 200) 
        {            
            Map < String, Object > resultMap = ( Map< String, Object> )JSON.deserializeUntyped( response.getBody() );
            access_token = ( String )resultMap.get( 'access_token' );
            instance_url = ( String )resultMap.get( 'instance_url' );
        }
    }
    
    @AuraEnabled
    public static void authenticate(String consumerKey, String consumerSecret, String username, String password, String securityToken){
        
        req.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        req.setBody(String.format(REQUEST_BODY ,new string[]{consumerKey,consumerSecret,username,password,securityToken}));
        req.setEndpoint(PRODUCTION);
        req.setMethod( 'POST');
        
        response = http.send( req );
        
        System.debug( 'Response Body is ' + response.getBody());
        
        if(response.getStatusCode() == 200) 
        {            
            Map < String, Object > resultMap = ( Map< String, Object> )JSON.deserializeUntyped( response.getBody() );
            access_token = ( String )resultMap.get( 'access_token' );
            instance_url = ( String )resultMap.get( 'instance_url' );
            
            // Add remote site setting for the destination org to make callout
            addRemotesiteSetting(instance_url);
            
            Authenticated_Org__c ao = new Authenticated_Org__c();
            ao.Is_Authorized__c =  true;
            ao.Organization_Name__c = 'Dev';
            ao.Access_Token__c = access_token;
            //ao.Instance_URL__c = instance_url;
            insert ao;
        }
    }  
    
    public static void addRemotesiteSetting(String instance_url){
        
        String json ='{"FullName":"Remotetest","Metadata":{"disableProtocolSecurity":false,"isActive":true,"url":"'+instance_url+'","urls":null,"description":"test"}}'; 
        String endpoint = URL.getOrgDomainURL().toExternalForm() +'/services/data/v41.0/tooling/sobjects/RemoteProxy/';
        string method  = 'POST';
        
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setBody(json); 
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.Debug('**** Remote Site Response: ' + response.getBody()); 
        
    }
    
    public static void getaccounts(){
        
        //authenticate();
        
        req = new HttpRequest();
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded' );
        req.setHeader('Authorization', 'Bearer ' + access_token );
        req.setEndpoint(instance_url +  '/services/data/v53.0/query/?q=SELECT+Name+FROM+Account'
                       );
        req.setMethod('GET');
        
        response = http.send( req );
        
        System.debug( 'Response Body is ' + response.getBody());
        
        if ( response.getStatusCode() == 200 ) {  
            
            List<Account> accountList = new List<Account>();
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> records = (List<Object>) jsonResponse.get('records');
            
            for (Object record : records) {
                Map<String, Object> recordMap = (Map<String, Object>) record;
                Account account = new Account();
                account.Id = (String) recordMap.get('Id');
                account.Name = (String) recordMap.get('Name');
                accountList.add(account);
            }
            system.debug('accountList'+accountList.size());
        }
    }
}