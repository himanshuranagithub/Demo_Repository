/* Class Name : MakeCalloutOAuth
 * Description : OAuth 2.0 Web server flow authentication
 * CreatedDate :
 * Create By : Bharat Girikon
 * 
 * LastModifiedDate :
 * LastModified Comment:
 * LastModified By :
 * 
 * */
public class MakeCalloutOAuth {
    
    public class MakeCalloutOAuthException Extends Exception{}
    
    public static final Integer METADATA_API_VERSION = Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/'));
    
    private string access_token      {get;set;}
    private string refresh_token     {get;set;}
    public  string valueToEncode     {get;set;}
    private string authCode          {get;set;}
    private string error             {get;set;}
    private string error_description {get;set;}
    private string recordId          {get;set;}
    
    private Authenticated_Org__c ao = new Authenticated_Org__c();
    
    /**
     * Constructor for the MakeCalloutOAuth class, which handles OAuth 2.0 authentication and token retrieval.
     *
     * This constructor is responsible for initializing key parameters and performing the following tasks:
     * 1. Extracts the 'state' and 'code' parameters from the current page reference URL to identify
     *    the Salesforce record and the authorization code.
     * 2. Calls the 'getAccessToken' method to retrieve an access token and refresh token using the authorization code.
     */
    public MakeCalloutOAuth(){
        recordId = System.currentPagereference().getParameters().get('state');
        valueToEncode = System.currentPagereference().getParameters().get('code');
        error = System.currentPagereference().getParameters().get('error');
        error_description = System.currentPagereference().getParameters().get('error_description');
    }
    
    /**
     * Retrieves an access token and refresh token from Salesforce OAuth 2.0 authorization code flow.
     *
     * This method performs the following tasks:
     * 1. Encodes the authorization code using UTF-8 encoding.
     * 2. Constructs the request body for the token endpoint with the encoded authorization code.
     * 3. Sends a POST request to the Salesforce token endpoint to exchange the authorization code
     *    for an access token and a refresh token.
     * 4. Parses the JSON response to extract the access token and refresh token.
     *
     * @throws AuraHandledException if an exception occurs during the process.
     */
    public void getAccessToken() {
        try
        {
            authCode = EncodingUtil.urlEncode(valueToEncode, 'UTF-8');
             
            if(authCode != null){
                String endpoint  = 'https://login.salesforce.com/services/oauth2/token?';
                String method = 'POST';
                
                Map<String, String> headers = new Map<String, String>();
                headers.put('Content-Type', 'application/x-www-form-urlencoded');
                
                String requestBody = 'grant_type=authorization_code&client_id=3MVG9pRzvMkjMb6kEpmq7wptlUtJvzS6joZBxfmYQR2.rUN0Bv_PddbO3y1SeHsv1NzbX4bxggvK1W5Ppmbqo&client_secret=FC4B3DAE2B4A6C7A48658A7BC2455A653366CE2A6543D6F4E69F7677A326DEEB&redirect_uri=https://girikon177-dev-ed--c.develop.vf.force.com/apex/Auth&code='+authCode;
                
                // Make the dynamic REST call and store the response in the 'response' variable
                HttpResponse response = RestCallout.makeRestCall(endpoint, method, headers, requestBody);
                
                system.debug('response'+response.getBody());
                
                // Parse the JSON response
                if(response.getStatusCode() == 200) 
                {      
                    ao.Is_Authorized__c = true;
                    Map < String, Object > resultMap = ( Map< String, Object> )JSON.deserializeUntyped( response.getBody() );
                    access_token = ( String )resultMap.get( 'access_token' );
                    refresh_token = ( String )resultMap.get( 'refresh_token' );
                }
            }
        }
        catch (Exception e) {
            system.debug(e.getMessage() +'---'+ e.getLineNumber() );
            throw new AuraHandledException(e.getMessage());
        } 
    }
    
    /**
     * Redirects to a Salesforce record page and updates an Authenticated Organization record.
     *
     * This method performs two main tasks:
     * 1. It updates an Authenticated_Org__c record identified by `recordId` with the provided access and refresh tokens
     *    and marks it as authorized.
     * 2. It constructs a PageReference to redirect to the Salesforce record page with the updated `recordId`.
     *
     * @return PageReference - A PageReference object that redirects to the Salesforce record page.
     */
    public PageReference redirect()
    { 
        ao.id = recordId;
        ao.Refresh_Token__c = refresh_token;
        ao.Access_Token__c = access_token;
        update ao;
        
        PageReference pg = new PageReference('/'+recordId);
        pg.setRedirect(true);
        return pg;  
    }
    
    /**
     * @AuraEnabled method to retrieve the Instance URL of an Authenticated Organization record.
     *
     * This method queries the Salesforce database to fetch the Instance URL associated with a specific Authenticated Organization record,
     * identified by the provided recordId. The Instance URL is essential for making authenticated API calls to the corresponding Salesforce org.
     *
     * @param recordId The Id of the Authenticated_Org__c record to retrieve the Instance URL from.
     * @return The Instance URL as a String
     */
    @AuraEnabled
    public static string getRecord (String recordId){
        return [SELECT Id,Instance_URL__c FROM Authenticated_Org__c WHERE Id=: recordId LIMIT 1].Instance_URL__c;
    }
    
    /**
     * Retrieves a list of authorized organizations from the Authenticated_Org__c object.
     * This method queries the Authenticated_Org__c object to fetch records where the 
     * 'Is_Authorized__c' field is set to 'True'. It returns a list of Authenticated_Org__c
     * records containing the 'Id' and 'Organization_Name__c' fields for authorized organizations.
     * 
     * @return List of authorized organizations.
     */
    @AuraEnabled
    public static List<Authenticated_Org__c> getAuthorizedOrgs (){
        return [SELECT Id,Organization_Name__c FROM Authenticated_Org__c WHERE Is_Authorized__c = True];
    }
    
    /**
     * Retrieves a list of sObject names available in an authorized Salesforce organization.
     * This method takes the 'recordId' parameter, which represents the Id of an authorized organization
     * (Authenticated_Org__c record). It queries the Authenticated_Org__c object to fetch the instance URL and
     * access token for the provided 'recordId'. Then, it makes a REST API call to Salesforce to retrieve
     * a list of available sObject names in the organization.
     * 
     * @param recordId The Id of the authorized organization (Authenticated_Org__c record).
     * @return List of sObject names in the authorized organization.
     * @throws AuraHandledException if any error occurs during the process.
     */    
    @AuraEnabled
    public static List<String> getsObjectList(String recordId) {
        try
        {
            // Define a list to store the names
            List<String> names = new List<String>();
            
            List<Authenticated_Org__c> authList = [SELECT Id,Instance_URL__c,Access_Token__c FROM Authenticated_Org__c WHERE Id=: recordId LIMIT 1];
            
            if(!authList.isEmpty()){
                
                String endpoint  = authList[0].Instance_URL__c + '/services/data/v59.0/sobjects';
                String method = 'GET';
                String authHeader = 'Bearer '+ authList[0].Access_Token__c;
                
                Map<String, String> headers = new Map<String, String>();
                headers.put('Authorization', authHeader);
                
                String requestBody = null;
                
                // Make the dynamic REST call and store the response in the 'response' variable
                HttpResponse response = RestCallout.makeRestCall(endpoint, method, headers, requestBody);
                
                system.debug('response'+response.getBody());
                
                // Parse the JSON response
                if(response.getStatusCode() == 200) 
                {   
                    Map < String, Object > resultMap = ( Map< String, Object> )JSON.deserializeUntyped( response.getBody() );
                    // Get the list of sobjects
                    List<Object> sobjects = (List<Object>) resultMap.get('sobjects');
                    
                    
                    // Iterate through the sobjects and extract the "name" field
                    for (Object st : sobjects) 
                    {
                        Map<String, Object> sobjectMap = (Map<String, Object>) st;
                        String name = (String) sobjectMap.get('name');
                        
                        if (name != null) {
                            names.add(name);
                        }
                    }
                    
                    system.debug(names);
                }else {
                    // Handle errors or other status codes
                    String errorMessage = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
                    throw new MakeCalloutOAuthException(errorMessage);
                }
            }
            
            return names;
        }
        catch (Exception e) {
            system.debug(e.getMessage() +'---'+ e.getLineNumber() );
            throw new MakeCalloutOAuthException(e.getMessage());
        } 
    }
    
    @AuraEnabled
    public static List<String> getsObjecFields(String recordId, String objectName) {
        try
        {
            // Define a list to store the names
            List<String> names = new List<String>();
            
            List<Authenticated_Org__c> authList = [SELECT Id,Instance_URL__c,Access_Token__c FROM Authenticated_Org__c WHERE Id=: recordId LIMIT 1];
            
            if(!authList.isEmpty()){
                
                String endpoint  = authList[0].Instance_URL__c + '/services/data/v59.0/sobjects/'+objectName+'/describe';
                String method = 'GET';
                String authHeader = 'Bearer '+ authList[0].Access_Token__c;
                system.debug(endpoint);
                Map<String, String> headers = new Map<String, String>();
                headers.put('Authorization', authHeader);
                
                String requestBody = null;
                
                // Make the dynamic REST call and store the response in the 'response' variable
                HttpResponse response = RestCallout.makeRestCall(endpoint, method, headers, requestBody);
                
                system.debug('response'+response.getBody());
                
                // Parse the JSON response
                if(response.getStatusCode() == 200) 
                {   
                    Map < String, Object > resultMap = ( Map< String, Object> )JSON.deserializeUntyped( response.getBody() );
                    // Get the list of sobjects
                    List<Object> sobjects = (List<Object>) resultMap.get('fields');
                    
                    
                    // Iterate through the sobjects and extract the "name" field
                    for (Object st : sobjects) 
                    {
                        Map<String, Object> sobjectMap = (Map<String, Object>) st;
                        String name = (String) sobjectMap.get('name');
                        
                        if (name != null) {
                            names.add(name);
                        }
                    }
                    
                    system.debug(names);
                }else {
                    // Handle errors or other status codes
                    String errorMessage = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
                    throw new MakeCalloutOAuthException(errorMessage);
                }
            }
            
            return names;
        }
        catch (Exception e) {
            system.debug(e.getMessage() +'---'+ e.getLineNumber() );
            throw new MakeCalloutOAuthException(e.getMessage());
        } 
    }    
}