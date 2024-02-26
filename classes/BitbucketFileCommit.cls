public class BitbucketFileCommit {

    // Replace these variables with your Bitbucket repository information
    private static final String BITBUCKET_USERNAME = 'bharat.aggarwal@girikon.com';
    private static final String BITBUCKET_APP_PASSWORD = 'Aglagl@123';
    private static final String REPO_OWNER = 'girikon-bharataggarwal';
    private static final String REPO_NAME = 'GirikonRepository';
    private static final String FILE_PATH = 'path/to/your/file.txt';

    public static void commitTextFile() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.bitbucket.org/2.0/repositories/' + REPO_OWNER + '/' + REPO_NAME + '/src');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + 'ATCTT3xFfGN0sMqJul-21zPeO-Xsf1j6Ulp9bn5SIncNxyRmI6lp6viada0bRrD33pmSoGHHxcnG-pZwXnh0zWDapFJ2WOI0rA4wtT6Ajlh0o48Vs408b2qJe6fn24nkFCVenLCwG6JnONt_CfvnEgGIAJPrJ96yq7xv3-qRTrsKtAIaB2XG0k0=BFDBEBB6');
        String fileContent = 'Hello this is test file';
        String requestBody = '{ "message": "Committing file via Apex", "files": [ { "path": "' + FILE_PATH + '", "content": "' + EncodingUtil.base64Encode(Blob.valueOf(fileContent)) + '" } ] }';
        request.setBody(requestBody);

        HttpResponse response = new Http().send(request);
        System.debug('response ' + response);
        // Handle the response based on your requirements
        System.debug('Bitbucket API Response: ' + response.getBody());
    }

    private static String createAuthHeader(String username, String password) {
        String credentials = username + ':' + password;
        Blob credentialsBlob = Blob.valueOf(credentials);
        return EncodingUtil.base64Encode(credentialsBlob);
    }
}