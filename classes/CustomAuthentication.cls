public with sharing class CustomAuthentication
{
	private final String AUTH_URL = 'https://login.salesforce.com/services/oauth2/token/';
	private final String JSON_CONTENT_TYPE = 'application/json';
	private final String POST_METHOD = 'POST';

	/*public Id createAccountCallout(){
		SF_Custom_Integration__mdt connectionData = getConnectionMetadata();
		SF_Auth authBody = getSFAccessToken(connectionData);
		Id acctId = createAccount(authBody);
		return acctId;
	}*/

	public SF_Custom_Integration__mdt getConnectionMetadata(){
		List<SF_Custom_Integration__mdt> connectionData = [SELECT Auth_URL__c, Client_Id__c, Client_Secret__c, Content_Type__c, grant_type__c, Password__c, Security_Token__c, Username__c FROM SF_Custom_Integration__mdt LIMIT 1];
		return connectionData[0];
	}

	public static void getSFAccessToken(){
        
        SF_Custom_Integration__mdt connectionData = [SELECT Auth_URL__c, Client_Id__c, Client_Secret__c, Content_Type__c, grant_type__c, Password__c, Security_Token__c, Username__c FROM SF_Custom_Integration__mdt LIMIT 1];
        
        String authURL = 'https://login.salesforce.com/services/oauth2/token/';
		authURL += '?grant_type=' + connectionData.grant_type__c;
		authURL += '&client_secret=' + connectionData.Client_Secret__c;
		authURL += '&client_id=' + connectionData.Client_Id__c;
		authURL += '&username=' + connectionData.Username__c;
		authURL += '&password=' + connectionData.Password__c;
		authURL += '&security_token=' + '9NicW9YnSnwoFQurge8qNTsY';
        
		HttpRequest authReq = new HttpRequest();
		authReq.setMethod('POST');
		authReq.setEndpoint(authURL);
		authReq.setHeader('Content-Type', connectionData.Content_Type__c);
		Http http = new Http();
		HttpResponse response = http.send(authReq);
        system.debug('response'+response);
		//SF_Auth authBody = SF_Auth.parse(response.getBody());
		//return authBody;
	}

	
	/*private Id createAccount(SF_Auth authBody){
		HttpRequest dataReq = new HttpRequest();
		Id accountId = null;
		dataReq.setMethod(POST_METHOD);
		dataReq.setEndpoint(ACCOUNT_CREATION_URL);
		dataReq.setHeader('Authorization', authBody.token_type + ' ' + authBody.access_token);
		dataReq.setHeader('Content-Type', JSON_CONTENT_TYPE);
		dataReq.setBody(JSON.serialize(wrapAccount(generateAccount())));
		Http http = new Http();
		HttpResponse response = http.send(dataReq);
		accountId = Id.valueOf(response.getBody().substringBetween('"', '"'));
		return accountId;
	}

	private Account generateAccount(){
		Account acct = new Account();
		acct.Name = 'Hi';
		acct.Phone = '8162221111';
		return acct;
	}

	private AccountWrapper wrapAccount(Account acct){
		AccountWrapper wrapper = new AccountWrapper();
		wrapper.acct = acct;
		return wrapper;
	}*/
}