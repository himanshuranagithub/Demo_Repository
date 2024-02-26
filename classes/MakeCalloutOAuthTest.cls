@isTest
public class MakeCalloutOAuthTest {
    
    @testsetup private static void create_data(){
        Authenticated_Org__c ao = new Authenticated_Org__c();
        ao.Organization_Name__c = 'Girikon Sandbox';
        ao.Instance_URL__c = 'https://login.salesforce.com';
        insert ao;
    }
    
    @isTest
    public static void default_test(){
        
        List<Authenticated_Org__c> authList = [SELECT Id FROM Authenticated_Org__c];
        PageReference pageRef = Page.Auth;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('code', '3khdhr3j83n3rr3kknkj7344343nbc434343');
        pageRef.getParameters().put('state', authList[0].id);
        Test.setMock(HttpCalloutMock.class, new MakeCalloutOAuthMock());  
        MakeCalloutOAuth ctrl = new MakeCalloutOAuth();
        test.starttest();
        ctrl.getAccessToken();
        test.stoptest();
        
    }
    
    @isTest
    public static void redirect_test(){
        List<Authenticated_Org__c> authList = [SELECT Id FROM Authenticated_Org__c];
        PageReference pageRef = Page.Auth; 
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('state',authList[0].id);
        MakeCalloutOAuth ctrl = new MakeCalloutOAuth();
        ctrl.redirect();
    }
    
    @isTest
    public static void getRecord_test(){
        List<Authenticated_Org__c> authList = [SELECT Id FROM Authenticated_Org__c];
        MakeCalloutOAuth.getRecord(authList[0].id);
    }
    
}