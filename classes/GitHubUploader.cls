public class GitHubUploader {
    
    
    
    public static void commitMultipleFilesInZipFuture(String branchName) {
        
        
        // Sample data for fileDataMapJSON
        Map<String, String> fileDataMap = new Map<String, String>();
        
        fileDataMap.put('file1.txt', 'This is the content of file 1.');
        fileDataMap.put('file2.txt', 'This is the content of file 2.');
        // Add more files as needed
        
        // Convert the map to JSON
        String fileDataMapJSON = JSON.serialize(fileDataMap);
        
        Map<String, String> fileDataMap1 = (Map<String, String>)JSON.deserialize(fileDataMapJSON, Map<String, String>.class);
        
        String correctedBranchName = branchName.replace(' ','_');
        system.debug('Branch Name after replace @@@@@@@@@ '+ branchName);
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        String baseEndpoint = 'https://api.github.com/repos/bharat491995/MergeConflictTesting/';
        String Gitbytoken = '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';
        String authorizationHeader = 'Bearer ' + Gitbytoken;
        
        // Prepare the list of file changes for the commit
        
        List<Map<String, String>> fileChanges = new List<Map<String, String>>();
        
        for (String key : fileDataMap1.keyset())
        {
            String fileName = key;
            String fileContent = fileDataMap.get(key);
            
            Map<String, String> fileChange = new Map<String, String>();
            fileChange.put('path', fileName);
            fileChange.put('content', fileContent);
            fileChange.put('type', 'blob');
            fileChange.put('mode', '100644');
            fileChanges.add(fileChange);
            
            // Additional debug logs for tracking file names and contents
            System.debug('File Name: ' + fileName);
            System.debug('File Content: ' + fileContent);
        }
        
        // Prepare the request body with the file changes
        Map<String, Object> treeData = new Map<String, Object>();
        treeData.put('base_tree', null);
        treeData.put('tree', fileChanges);
        
        String bodyConvert = JSON.serialize(treeData);
        System.debug('Body Convert File ===> ' + bodyConvert);
        
        // Create a tree for the commit
        req = new HttpRequest();
        req.setEndpoint(baseEndpoint + 'git/trees');
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(bodyConvert);
        HTTPResponse res = http.send(req);
        
        // Check the response
        String responseBody = res.getBody();
        System.debug('Response Body for tree creation ===> ' + responseBody);
        
        // Check the status code and response body
        Integer statusCode1 = res.getStatusCode();
        String statusVal1 = res.getStatus();
        System.debug('statusCode1->>>' + statusCode1);
        System.debug('statusVal1->>>' + statusVal1);
        
        // Create the commit using the tree
        Map<String, Object> treeResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        String treeSha = (String) treeResponse.get('sha');
        
        Map<String, Object> commitData = new Map<String, Object>();
        commitData.put('message', 'TestComment');
        //treeData.put('base_tree', treeSha); // Set the base_tree to the new tree sha
        commitData.put('tree', treeSha); // Update the tree data in the commitData map
        bodyConvert = JSON.serialize(commitData);
        
        req = new HttpRequest();
        req.setEndpoint(baseEndpoint + 'git/commits');
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(bodyConvert);
        res = http.send(req);
        
        // Check the response
        responseBody = res.getBody();
        System.debug('Response Body for commit creation ===> ' + responseBody);
        
        // Get the status code of the final request and return it
        Integer statusCode2 = res.getStatusCode();
        String statusVal2 = res.getStatus();
        System.debug('statusCode2->>>' + statusCode2);
        System.debug('statusVal2->>>' + statusVal2);
        
        Map<String, Object> commitResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        String commitSha = (String) commitResponse.get('sha');
        
        // Update the branch reference to the new commit
        Map<String, Object> refData = new Map<String, Object>();
        refData.put('ref', 'refs/heads/'+correctedBranchName);
        refData.put('sha', commitSha);
        refData.put('force', true);
        
        bodyConvert = JSON.serialize(refData);
        
        req = new HttpRequest();
 
        req.setEndpoint(baseEndpoint + 'git/refs/heads/'+correctedBranchName);

        req.setMethod('PATCH');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(bodyConvert);
        res = http.send(req);
        
        // Check the response
        responseBody = res.getBody();
        
        System.debug('Response Body for updating branch reference ===> ' + responseBody);
        
        // Get the status code of the final request and return it
        Integer statusCode3 = res.getStatusCode();
        String statusVal3 = res.getStatus();
        System.debug('statusCode3->>>' + statusCode3);
        System.debug('statusVal3->>>' + statusVal3);
     
        //return statusCode3; 
    }
    
}