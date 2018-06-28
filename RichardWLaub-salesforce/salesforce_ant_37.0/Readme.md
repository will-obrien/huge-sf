# Force.com Migration Tool

This is the Summer '16 version of the Force.com Migration Tool. The Force.com Migration Tool is a Java/Ant-based command-line utility for moving metadata between a local directory and a Salesforce organization. For more information, see the [Force.com Migration Tool Guide](http://wiki.developerforce.com/page/Migration_Tool_Guide#Official_Documentation).

## Installation

1.  Download [Apache Ant](http://ant.apache.org/bindownload.cgi), version 1.6 or newer.
2.  To ensure that the appropriate environment variables are set for Ant, follow the instructions in [Installing Ant](http://ant.apache.org/manual/install.html).
3.  If your network requires an HTTP proxy, follow the instructions in [Proxy Configuration](http://ant.apache.org/manual/proxy.html).

<u>Note</u>: The Force.com Migration Tool uses the `ant-salesforce.jar` file that's in the distribution zip. If you have another version of `ant-salesforce.jar` in the Ant installation `lib` directory, delete it to ensure that the latest version from the zip file is used. You don't need to copy this jar file to your Ant installation `lib` directory.

## Deploying Sample Metadata

1.  Go to the [sample](sample) subdirectory.
2.  Open the [build.properties](sample/build.properties) file and make the following substitutions:
    *   `sf.username` - a valid Salesforce username
    *   `sf.password` - a valid Salesforce password  
        If you are using a security token, paste the 25-digit token value to the end of your password.
    *   `sf.serverurl` - the Salesforce server URL  
        A sandbox or Developer Edition organization is strongly recommended for testing.<u>Note</u>: If you want to use a Salesforce session for authentication instead of a username and password, uncomment the `sf.sessionId` property and provide a valid session ID. Also, make sure to comment out the `sf.username` and `sf.password` properties.
3.  Open a command shell and navigate to the `sample` subdirectory.
4.  Run `ant test`.  
    This will deploy sample metadata into your organization and retrieve it again into a local directory. Look for the custom object `myobj` and its corresponding page layout in your organization, and go to `sample/retrieveOutput` to see the results of the retrieve.

The sample `build.xml` contains other targets illustrating various deploy and retrieve options. Run `ant -p` to list the build targets.

## Using Deploy and Retrieve

Use the deploy and retrieve tasks to create, update, and retrieve metadata. This reference lists the attributes available for each task.

### Deploy

The **deploy** task uses a set of Salesforce metadata components on your system to create or update the corresponding objects in your organization.

<dl>

<dt>**username**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce username for login.</dd>

<dt>**password**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce password for login. If you are using a security token, paste the 25-digit token value to the end of your password.</dd>

<dt>**sessionId**</dt>

<dd>Required if 'username' and 'password' aren't specified. The ID of an active Salesforce session. You can use a session ID for authentication only when the username and password aren't defined in the `build.properties` file.</dd>

<dt>**serverurl**</dt>

<dd>Optional. Defaults to 'https://login.salesforce.com'. This is useful for working against the sandbox instance on test.salesforce.com.</dd>

<dt>**pollWaitMillis**</dt>

<dd>Optional. Defaults to 10000\. The number of milliseconds to wait between each poll of Salesforce to retrieve the results of the deploy.</dd>

<dt>**checkOnly**</dt>

<dd>Optional (true/false). Defaults to false. Only check the validity of the deployed files, don't make any changes to Salesforce.</dd>

<dt>**maxPoll**</dt>

<dd>Optional. Defaults to 200\. The number of times to poll Salesforce for the results of the task.</dd>

<dt>**purgeOnDelete**</dt>

<dd>Optional (true/false). Defaults to false. If set to true, the deleted components in the destructiveChanges.xml manifest file aren't stored in the Recycle Bin. Instead, they become immediately eligible for deletion. Do not set this argument for deployment to production organizations.</dd>

<dt>**deployRoot**</dt>

<dd>Required if 'zipFile' is not specified. Specifies the root of the directory tree of files to deploy. See Working with the Zip File in the [Metadata API Developer's Guide](http://www.salesforce.com/us/developer/docs/api_meta/index.htm) for more information.</dd>

<dt>**zipFile**</dt>

<dd>Required if 'deployRoot' is not specified. Specifies the path of the metadata zip file to be deployed. Either zipFile or deployRoot must be specified. See Working with the Zip File in the [Metadata API Developer's Guide](http://www.salesforce.com/us/developer/docs/api_meta/index.htm) for more information.</dd>

<dt>**singlePackage**</dt>

<dd>Optional (true/false). Defaults to false. Declares that the deployRoot/zipFile points to a directory structure with a single package, as opposed to a set of packages.</dd>

<dt>**allowMissingFiles**</dt>

<dd>Optional (true/false). Defaults to false. Specifies whether a deploy succeeds even if files that are specified in package.xml are not in the zip file. Do not set this argument for deployment to production organizations.</dd>

<dt>**autoUpdatePackage**</dt>

<dd>Optional (true/false). Defaults to false. Specifies whether a deploy should continue even if files present in the zip file are not specified in package.xml. Do not set this argument for deployment to production organizations.</dd>

<dt>**rollbackOnError**</dt>

<dd>Optional (true/false). Defaults to true. Indicates whether any failure causes a complete rollback (true) or not (false). If false, whatever set of actions can be performed without errors are performed, and errors are returned for the remaining actions. This parameter must be set to true if you are deploying to a production organization.</dd>

<dt>**ignoreWarnings**</dt>

<dd>Optional (true/false). Defaults to false. This setting indicates that a deployment should succeed even if there are warnings (true) or that one or more warnings will cause the deployment to fail and roll back (false). If there are errors, as opposed to warnings, the deployment will always fail and roll back.</dd>

<dt>**testLevel**</dt>

<dd>Optional. Specifies which tests are run as part of a deployment. The test level is enforced regardless of the types of components that are present in the deployment package. Valid values are:

*   **NoTestRun**—No tests are run. This option applies only to deployments to development environments, such as sandbox, Developer Edition, or trial organizations. This option is the default for development environments.
*   **RunSpecifiedTests**—Only the tests that you specify in the **runTest** option are run. Code coverage requirements differ from the default coverage requirements when using this option. Each class and trigger in the deployment package must be covered by the executed tests for a minimum of 75% code coverage.
*   **RunLocalTests**—All tests in your organization are run, except the ones that originate from installed managed packages.
*   **RunAllTestsInOrg**—All tests are run. The tests include all tests in your organization, including tests of managed packages.

</dd>

<dt>**runTest**</dt>

<dd>Optional child elements. A list of Apex classes containing tests run after deploy. For production deployments, the specified tests must cover each Apex class and trigger in the deployment package for a minimum of 75% code coverage. If any of these tests fail or doesn't meet code coverage requirements, and if the rollbackOnError parameter is set to true, the deployment is rolled back and no changes are made to your organization.</dd>

<dt>**logType**</dt>

<dd>Optional. Defaults to 'None'. The debug logging level for tests. Valid options are 'None', 'Debugonly', 'Db', 'Profiling', 'Callout', and 'Detail'.</dd>

<dt>**trace**</dt>

<dd>Optional (true/false). Defaults to false. Prints the SOAP requests and responses sent to Salesforce to the console. Note: This will show the user's password in plain text during login.</dd>

</dl>

### DeployRecentValidation

The **deployRecentValidation** task deploys a recent validation by using the validation ID. The validation must have run successfully and all tests must have passed in the last four days.

<dl>

<dt>**username**</dt>

<dd>Required if 'sessionId' isn't specified.. The Salesforce username for login.</dd>

<dt>**password**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce password for login. If you are using a security token, paste the 25-digit token value to the end of your password.</dd>

<dt>**sessionId**</dt>

<dd>Required if 'username' and 'password' aren't specified. The ID of an active Salesforce session. You can use a session ID for authentication only when the username and password aren't defined in the `build.properties` file.</dd>

<dt>**serverurl**</dt>

<dd>Optional. Defaults to 'https://login.salesforce.com'. This is useful for working against the sandbox instance on test.salesforce.com.</dd>

<dt>**recentValidationId**</dt>

<dd>Required. The ID of a validation that was successfully run in the last four days.</dd>

<dt>**rollbackOnError**</dt>

<dd>Optional (true/false). Defaults to true. Indicates whether any failure causes a complete rollback (true) or not (false). If false, whatever set of actions can be performed without errors are performed, and errors are returned for the remaining actions. This parameter must be set to true if you are deploying to a production organization.</dd>

<dt>**maxPoll**</dt>

<dd>Optional. Defaults to 200\. The number of times to poll Salesforce for the results of the task.</dd>

<dt>**pollWaitMillis**</dt>

<dd>Optional. Defaults to 10000\. The number of milliseconds to wait between each poll of Salesforce to retrieve the results of the deploy.</dd>

<dt>**trace**</dt>

<dd>Optional (true/false). Defaults to false. Prints the SOAP requests and responses sent to Salesforce to the console. Note: This will show the user's password in plain text during login.</dd>

</dl>

### Retrieve

The **retrieve** task downloads a set of metadata components from your organization into a set of local XML files.

<dl>

<dt>**username**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce username for login.</dd>

<dt>**password**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce password for login. If you are using a security token, paste the 25-digit token value to the end of your password.</dd>

<dt>**sessionId**</dt>

<dd>Required if 'username' and 'password' aren't specified. The ID of an active Salesforce session. You can use a session ID for authentication only when the username and password aren't defined in the `build.properties` file.</dd>

<dt>**serverurl**</dt>

<dd>Optional. Defaults to 'https://login.salesforce.com'. This is useful for working against a sandbox instance on test.salesforce.com.</dd>

<dt>**retrieveTarget**</dt>

<dd>Required. The root of the directory structure into which the metadata files are retrieved.</dd>

<dt>**packageNames**</dt>

<dd>Required if 'unpackaged' is not specified. A comma-separated list of the names of the packages to retrieve.</dd>

<dt>**apiVersion**</dt>

<dd>Optional. Defaults to 37.0\. The API version to use for the retrieved metadata files.</dd>

<dt>**pollWaitMillis**</dt>

<dd>Optional. Defaults to 10000. Number of milliseconds to wait between each poll of Salesforce to retrieve the results.</dd>

<dt>**maxPoll**</dt>

<dd>Optional. Defaults to 20\. The number of times to poll Salesforce for the results of the task.</dd>

<dt>**singlePackage**</dt>

<dd>Optional (true/false). Defaults to true. If retrieving multiple packages, this must be false. If set to false, the retrieved zip file includes an extra top-level directory with a subdirectory for each package.</dd>

<dt>**unpackaged**</dt>

<dd>Required if 'packageNames' is not specified. The name of a manifest file that specifies the components to retrieve.</dd>

<dt>**unzip**</dt>

<dd>Optional (true/false). Defaults to true. If true, the retrieved components are unzipped. If false, the retrieved components are saved as a zip file in the retrieveTarget directory.</dd>

<dt>**trace**</dt>

<dd>Optional (true/false). Defaults to false. Prints the SOAP requests and responses sent to Salesforce to the console. Note: This will show the user's password in plain text during login.</dd>

</dl>

### BulkRetrieve

The **bulkRetrieve** task downloads a large number of metadata objects of a particular type from your organization into a set of local files. It automatically generates the list of objects to be retrieved and batches the retrieve process based on the **batchSize** attribute.

<dl>

<dt>**username**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce username for login.</dd>

<dt>**password**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce password for login. If you are using a security token, paste the 25-digit token value to the end of your password.</dd>

<dt>**sessionId**</dt>

<dd>Required if 'username' and 'password' aren't specified. The ID of an active Salesforce session. You can use a session ID for authentication only when the username and password aren't defined in the `build.properties` file.</dd>

<dt>**serverurl**</dt>

<dd>Optional. Defaults to 'https://login.salesforce.com'. This is useful for working against a sandbox instance on test.salesforce.com.</dd>

<dt>**retrieveTarget**</dt>

<dd>Required. The root of the directory structure into which the metadata files are retrieved.</dd>

<dt>**metadataType**</dt>

<dd>Required. Name of metadata type to be retrieved, such as CustomObject or Report.</dd>

<dt>**containingFolder**</dt>

<dd>Optional. If the metadata is contained in a folder, the containingFolder should be the name of the folder from which the contents are retrieved.</dd>

<dt>**batchSize**</dt>

<dd>Optional. Defaults to 10\. The number of items to retrieve while doing multi-part retrieve.</dd>

<dt>**apiVersion**</dt>

<dd>Optional. Defaults to 37.0\. The API version to use for the retrieved metadata files.</dd>

<dt>**maxPoll**</dt>

<dd>Optional. Defaults to 20\. The number of times to poll Salesforce for the results of the task.</dd>

<dt>**unzip**</dt>

<dd>Optional (true/false). Defaults to true. If true, the retrieved components are unzipped. If false, the retrieved components are saved as a zip file in the retrieveTarget directory.</dd>

<dt>**trace**</dt>

<dd>Optional (true/false). Defaults to false. Prints the SOAP requests and responses sent to Salesforce to the console. Note: This will show the user's password in plain text during login.</dd>

</dl>

### CancelDeploy

The **cancelDeploy** task cancels a deployment that's in progress or queued.

<dl>

<dt>**username**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce username for login.</dd>

<dt>**password**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce password for login. If you are using a security token, paste the 25-digit token value to the end of your password.</dd>

<dt>**sessionId**</dt>

<dd>Required if 'username' and 'password' aren't specified. The ID of an active Salesforce session. You can use a session ID for authentication only when the username and password aren't defined in the `build.properties` file.</dd>

<dt>**serverurl**</dt>

<dd>Optional. Defaults to 'https://login.salesforce.com'. This is useful for working against the sandbox instance on test.salesforce.com.</dd>

<dt>**requestId**</dt>

<dd>Required. The ID of an in-progress or queued deployment to cancel.</dd>

<dt>**maxPoll**</dt>

<dd>Optional. Defaults to 200\. The number of times to poll Salesforce for the results of the task.</dd>

<dt>**pollWaitMillis**</dt>

<dd>Optional. Defaults to 10000\. The number of milliseconds to wait between each poll of Salesforce to retrieve the results of the deploy.</dd>

<dt>**trace**</dt>

<dd>Optional (true/false). Defaults to false. Prints the SOAP requests and responses sent to Salesforce to the console. Note: This will show the user's password in plain text during login.</dd>

</dl>

### ListMetadata

The **listMetadata** task gets detail information about metadata components of a particular type. This call is useful when you want to identify individual components in your manifest file for the **retrieve** task or if you want a high-level view of particular components in your organization.

<dl>

<dt>**username**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce username for login.</dd>

<dt>**password**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce password for login. If you are using a security token, paste the 25-digit token value to the end of your password.</dd>

<dt>**sessionId**</dt>

<dd>Required if 'username' and 'password' aren't specified. The ID of an active Salesforce session. You can use a session ID for authentication only when the username and password aren't defined in the `build.properties` file.</dd>

<dt>**serverurl**</dt>

<dd>Optional. Defaults to 'https://login.salesforce.com'. This is useful for working against a sandbox instance on test.salesforce.com.</dd>

<dt>**metadataType**</dt>

<dd>Required. Name of metadata type to be retrieved, such as CustomObject or Report.</dd>

<dt>**folder**</dt>

<dd>The folder associated with the component. This field is required for components that use folders, such as Dashboard, Document, EmailTemplate, or Report.</dd>

<dt>**apiVersion**</dt>

<dd>Optional. Defaults to 37.0\. Returns information about the metadata components available in the API version specified.</dd>

<dt>**resultFilePath**</dt>

<dd>Optional. Specifies the path of the output file where results are stored. The default output is the console.</dd>

<dt>**trace**</dt>

<dd>Optional (true/false). Defaults to false. Prints the SOAP requests and responses sent to Salesforce to the console. Note: This will show the user's password in plain text during login.</dd>

</dl>

### DescribeMetadata

The **describeMetadata** task gets detail information about the metadata types that are supported in a particular API version. See the [Metadata API Developer's Guide](http://www.salesforce.com/us/developer/docs/api_meta/index.htm) for more information about metadata types.

<dl>

<dt>**username**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce username for login.</dd>

<dt>**password**</dt>

<dd>Required if 'sessionId' isn't specified. The Salesforce password for login. If you are using a security token, paste the 25-digit token value to the end of your password.</dd>

<dt>**sessionId**</dt>

<dd>Required if 'username' and 'password' aren't specified. The ID of an active Salesforce session. You can use a session ID for authentication only when the username and password aren't defined in the `build.properties` file.</dd>

<dt>**serverurl**</dt>

<dd>Optional. Defaults to 'https://login.salesforce.com'. This is useful for working against a sandbox instance on test.salesforce.com.</dd>

<dt>**apiVersion**</dt>

<dd>Optional. Defaults to 37.0\. Describes only the metadata components available in the API version specified.</dd>

<dt>**resultFilePath**</dt>

<dd>Optional. Specifies the path of the output file where results are stored. The default output is the console.</dd>

</dl>
