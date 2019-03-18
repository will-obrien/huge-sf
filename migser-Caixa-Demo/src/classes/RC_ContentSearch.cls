/*
    RC_ContentSearch - Controller provides a list of relevant content for the record based on keywords (default: RC_Keywords__c)
    Author: Mike Hineline
    
    Copyright (c) 2013, salesforce.com, Inc.
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without modification, 
    are permitted provided that the following conditions are met:
    
        * Redistributions of source code must retain the above copyright notice, 
        this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright notice, 
        this list of conditions and the following disclaimer in the documentation 
        and/or other materials provided with the distribution.
        * Neither the name of the salesforce.com, Inc. nor the names of its contributors 
        may be used to endorse or promote products derived from this software 
        without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
    IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
    INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
    LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
    OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
    OF THE POSSIBILITY OF SUCH DAMAGE.
*/
global with sharing class RC_ContentSearch {
    /*
        Define member variables
    */
    // Preference flag to return only Content (true) or Content and Files (false)
    public static Boolean CONTENT_ONLY = false;
    // Member variable for the number of search results displayed per page (currently only 1 page)
    public Integer RESULTS_PER_PAGE = 5;

    // Member variable to hold the current record
    public final sObject thisRecord {get; private set;}
    // Member variable to hold a flag to show the form
    public Boolean showForm {get; private set;}
    // Member variable to hold the sObject type
    public String thisObjectType {get; private set;}
    // Member variable to hold flag for RC_Keywords__c existance on the object
    public Boolean hasKeywordsField {get; private set;}
    // Member variable for the record's Keywords 
    public String recordSearchString {get; set;}
    // Member variable for the record's Name 
    public String recordName {get; set;}
    // Member variable for the record's object icon 
    public String objectIcon {get; private set;}
    // Member variable for the total number of search results available (not currently displayed)
    public Integer totalResults {get; private set;}
    // Member variable to store whether or not Content is available in this org to this user
    public Boolean contentAvailable {get; private set;}
    // Member variable for the way Content is handled ('Content' if Content is available to the User or 'File' otherwise)
    public String contentType {get; private set;}
    // Member variable for the full list of record's Related Content data (up to totalResults in size)
    public List<ContentVersionContainer> recordContentAll {get; private set;}

    /*
        Constructor to initialize the Content list based on the record's RC_Keywords__c
    */
    public RC_ContentSearch() {
        /*
            Initialize variables
        */
        // Get the record ID from the Visualforce page
        ID thisRecordID = ApexPages.currentPage().getParameters().get('id');
        
        // Prevent form from showing when the record ID is not available
        //  For example: during record creation
        if (thisRecordID == null) {
            showForm = false;
            return;
        } else {
            showForm = true;
        }

        // Get the object type and set the thisObjectType member variable
        thisObjectType = getObjectType(thisRecordID);

        /* Determine the sObject's name field
            This will be sObject.Name for most objects and sObject.Subject for Tasks/Events and Cases */
        // Get the sObject field Map info from the ID
        Schema.SObjectType token = thisRecordID.getSObjectType();
        Schema.DescribeSObjectResult dr = token.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dr.fields.getMap();
        String nameFieldName = '';
        if (fieldMap.containsKey('Name')) {
            // Most Salesforce objects have a Name field
            nameFieldName = 'Name';
        } else if (fieldMap.containsKey('Subject')) {
            // Tasks/Events do not have a Name field so use Subject
            nameFieldName = 'Subject';
        }

        /* Check to see if RC_Keywords__c field exists & is accessible to the user on the object
            and set the hasKeywordsField member variable */
        hasKeywordsField = testHasKeywordsField(thisRecordID);

        /* Query the record for the Id, name, keywords */
        // Build the query string
        String thisRecordQueryString = 'SELECT ';
        thisRecordQueryString += 'Id';
        if (nameFieldName != '') {
            thisRecordQueryString += ', ' + nameFieldName;
        }
        if (hasKeywordsField) {
            thisRecordQueryString += ', RC_Keywords__c';
        }
        thisRecordQueryString += ' FROM ' + thisObjectType;
        thisRecordQueryString += ' WHERE Id = \'' + thisRecordID + '\'';
        thisRecordQueryString += ' LIMIT 1';
        // Query the record
        try {
            thisRecord = Database.query(thisRecordQueryString);
        } catch (DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); return; }

        // If the record is found, initialize the record name & object file icon
        // Note: thisRecord is a generic sObject, hence the use of getter methods
        recordContentAll = new List<ContentVersionContainer>();
        if (thisRecord.Id != null) {
            // Get the record's Name (or ID if the Name/Subject could not be determined)
            if (nameFieldName != '') {
                recordName = String.valueOf(thisRecord.get(nameFieldName));
            } else {
                recordName = thisRecordID;
            }
            
            // Get the object's icon filename
            objectIcon = getObjectIconFilename(thisObjectType);
        }

        /* Initialize the Content search */
        // Initialize the totalResults to 0
        totalResults = 0;
        // Initialize the content availability and type (Content or File)
        contentAvailable = contentAvailableCheck();
        if (contentAvailable) {
            contentType = 'Content';
        } else {
            contentType = 'File';
        }
        // Perform the initial search with the record's keywords as the search string
        //  If the object contains a keyword field, use it's contents for the search string
        //  Otherwise, use the record's name
        if (thisRecord.Id != null) {
            if (hasKeywordsField) {
                recordSearchString = String.valueOf(thisRecord.get('RC_Keywords__c'));
            } else {
                recordSearchString = recordName;
            }
            performSearch(recordSearchString);
        }
    }
    
    /*
        ContentVersionContainer - wrapper class for storing ContentVersion sObject & related information
    */
    public class ContentVersionContainer {
        // Getter/Setter for the contained sObject
        public ContentVersion contentVersionSObject {get; private set;}
        // Member variable for the formatted date string
        public String contentModifiedDateFormatted {get; private set;}
        // Member variable for the formatted file type string
        public String fileTypeFormatted {get; private set;}
        // Member variable for the file icon filename
        public String iconFilename {get; private set;}

        // Overloaded constructor to initialize formatted strings when given a ContentVersion input
        public ContentVersionContainer(ContentVersion c) {
            contentVersionSObject = c;

            // Format the date string
            contentModifiedDateFormatted = '';
            if (c.ContentModifiedDate != null) {
                contentModifiedDateFormatted = c.ContentModifiedDate.month() + '/' + c.ContentModifiedDate.day() + '/' + c.ContentModifiedDate.year();
            }

            // Format the FileType string
            fileTypeFormatted = '';
            if (c.FileType != null) {
                fileTypeFormatted = cleanFileType(c.FileType,c.PathOnClient);
            }
            
            // Determine the icon filename
            iconFilename = 'unknown.svg';
            if (fileTypeFormatted != null) {
                iconFilename = getIconFilename(fileTypeFormatted);
            }
        }
    }
    
    /*
        getObjectType - method to determine the type of an sObject given an ID
        Inputs:
            ID - record ID for which the sObject type will be returned
        Returns:
            String - sObject type
    */
    public String getObjectType(ID testRecordID) {
        // Get the sObject token from the ID
        Schema.SObjectType token = testRecordID.getSObjectType();
        // Using the token, do a describe and construct query the record's Name
        Schema.DescribeSObjectResult dr = token.getDescribe();
        // Determine the sObject type for the current record
        String testObjectType = dr.getName();

        // Return the sObject type
        return testObjectType;
    }
    
    /*
        testHasKeywordsField - method to check if the sObject type of the given record has an RC_Keywords__c field
            and whether or not the field is accessible to the user
        Inputs:
            ID - record ID for which the Object will be tested
        Returns:
            true if the RC_Keywords__c field exists for the sObject and is accessible to the user
            false if the RC_Keywords__c field does not exist for the sObject or if it is not accessible to the user
    */
    public Boolean testHasKeywordsField(ID testRecordID) {
        // Get the sObject token from the ID
        Schema.SObjectType token = testRecordID.getSObjectType();
        // Using the token, do a describe and construct query the record's Name
        Schema.DescribeSObjectResult dr = token.getDescribe();
        // Determine the sObject type for the current record
        String thisObjectType = dr.getName();
        // Determine the record's name field
        //  This will be sObject.Name for most objects and sObject.Subject for Tasks/Events and Cases
        Map<String, Schema.SObjectField> fieldMap = dr.fields.getMap();

        // Check to see if RC_Keywords__c field exists & is accessible to the user on the object
        Boolean testHasKeywords;
        if (fieldMap.containsKey('RC_Keywords__c')) {
            Boolean keywordsAccessible = fieldMap.get('RC_Keywords__c').getDescribe().isAccessible();
            if (keywordsAccessible) {
                testHasKeywords = true;
            } else {
                testHasKeywords = false;
            }
        } else {
            testHasKeywords = false;
        }

        // Return the flag indicating if the RC_Keywords__c field is available for this record
        return testHasKeywords;
    }

    /*
        performSearch - method to perform the content search and update the relevant content lists
        Inputs:
        - String searchString - the search string on which the content should be searched
        Returns: none
        Actions:
        - Update this.recordContentAll with all search results
        - Update this.totalResults with full count of results
    */
    public void performSearch(String searchString) {
        // Ensure we don't receive a null string
        if (searchString == null) {
            return; 
        }
        /*
            Generate a list of keywords for the from the input searchString
            Two key variables:
                Set<String> keywordSearchSet - Set containing the keywords
                String keywordsSearchString - String containing the keywords separated by OR for SOSL
        */
        // List of ignored keywords
        Set<String> stopWords = new Set<String>{'a', 'about', 'above', 'above', 'across', 'after', 'afterwards', 'again', 'against', 'all', 'almost', 'alone', 'along', 'already', 'also','although','always','am','among', 'amongst', 'amoungst', 'amount',  'an', 'and', 'another', 'any','anyhow','anyone','anything','anyway', 'anywhere', 'are', 'around', 'as',  'at', 'back','be','became', 'because','become','becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'below', 'beside', 'besides', 'between', 'beyond', 'bill', 'both', 'bottom','but', 'by', 'call', 'can', 'cannot', 'cant', 'co', 'con', 'could', 'couldnt', 'cry', 'de', 'describe', 'detail', 'do', 'done', 'down', 'due', 'during', 'each', 'eg', 'eight', 'either', 'eleven','else', 'elsewhere', 'empty', 'enough', 'etc', 'even', 'ever', 'every', 'everyone', 'everything', 'everywhere', 'except', 'few', 'fifteen', 'fify', 'fill', 'find', 'fire', 'first', 'five', 'for', 'former', 'formerly', 'forty', 'found', 'four', 'from', 'front', 'full', 'further', 'get', 'give', 'go', 'had', 'has', 'hasnt', 'have', 'he', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'him', 'himself', 'his', 'how', 'however', 'hundred', 'ie', 'if', 'in', 'inc', 'indeed', 'interest', 'into', 'is', 'it', 'its', 'itself', 'keep', 'last', 'latter', 'latterly', 'least', 'less', 'ltd', 'made', 'many', 'may', 'me', 'meanwhile', 'might', 'mill', 'mine', 'more', 'moreover', 'most', 'mostly', 'move', 'much', 'must', 'my', 'myself', 'name', 'namely', 'neither', 'never', 'nevertheless', 'next', 'nine', 'no', 'nobody', 'none', 'noone', 'nor', 'not', 'nothing', 'now', 'nowhere', 'of', 'off', 'often', 'on', 'once', 'one', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'our', 'ours', 'ourselves', 'out', 'over', 'own','part', 'per', 'perhaps', 'please', 'put', 'rather', 're', 'same', 'see', 'seem', 'seemed', 'seeming', 'seems', 'serious', 'several', 'she', 'should', 'show', 'side', 'since', 'sincere', 'six', 'sixty', 'so', 'some', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhere', 'still', 'such', 'system', 'take', 'ten', 'than', 'that', 'the', 'their', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'thereupon', 'these', 'they', 'thickv', 'thin', 'third', 'this', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'top', 'toward', 'towards', 'twelve', 'twenty', 'two', 'un', 'under', 'until', 'up', 'upon', 'us', 'very', 'via', 'was', 'we', 'well', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'with', 'within', 'without', 'would', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'the'};
        // Replace special characters with spaces
        //  spaces are used in place of removing the characters in case there is a string like "test-string")
        String cleanKeywords = searchString.replaceAll('[\\p{Punct}]',' ');
        // Put the space separated keywords into a List for manipulation
        List<String> workingKeywordList = new List<String>();
        workingKeywordList = cleanKeywords.split(' ');
        Set<String> keywordSearchSet = new Set<String>();
        String keywordSearchString = '';
        // Add the keywords ot the Set and string skipping stop words and blanks
        for (String s : workingKeywordList) {
            if (!stopWords.contains(s) && !s.isWhiteSpace()) {
                keywordSearchSet.add(s.toLowerCase());
                keywordSearchString += s + ' OR ';
            }
        }
        // Strip the trailing ' OR '
        keywordSearchString = keywordSearchString.removeEnd(' OR ');
        
        /*
            Perform the SOSL (case insensitive) search on ContentVersion for the keywordSearchString
                Require a minimum of 3 characters to search
                Maximum query size = this.RESULTS_PER_PAGE
        */
        // Filter the query string based on the availabilty of Content and CONTENT_ONLY setting
        //  Note that if CONTENT_ONLY = true but Content is not available for the user, nothing will be returned
        String queryFilterString = '';
        if (contentAvailable == false) {
            if (CONTENT_ONLY == false) {
                // Content is not available and CONTENT_ONLY not set
                //  Limit the search to only non-Content (Files)
                queryFilterString = ' AND Origin<>\'C\'';
            } else {
                // Content is not available but CONTENT_ONLY is set
                //  Return no results
                this.RESULTS_PER_PAGE = 0;
            }
        } else if (CONTENT_ONLY == true) {
            // CONTENT_ONLY is set, return only Content (Origin=C)
            queryFilterString = ' AND Origin=\'C\'';
        }
        
        // Clear the existing content list
        this.recordContentAll.clear();
        
        // Peform the search
        List<ContentVersion> returnContent = new List<ContentVersion>();
        if (keywordSearchString.length() > 2) {
            String contentQueryString = 'FIND :keywordSearchString IN ALL FIELDS';
            contentQueryString += ' RETURNING ContentVersion (Id, Title, FileType, PathOnClient, ContentSize, ContentDocumentId, ContentModifiedDate';
            contentQueryString += ', Description, TagCsv, PositiveRatingCount, NegativeRatingCount';
            contentQueryString += ' WHERE IsLatest = TRUE AND IsDeleted = FALSE';
            contentQueryString += queryFilterString;
            contentQueryString += ')';
            contentQueryString += ' LIMIT ' + this.RESULTS_PER_PAGE;
            List<List<ContentVersion>> rawContentList = new List<List<ContentVersion>>();
            try {
                rawContentList = search.query(contentQueryString);
            } catch (DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); return; }

            // Add any non-deleted content to the result list member variables
            for (ContentVersion c : rawContentList[0]) {
                // Add the content to the full result list
                this.recordContentAll.add( new ContentVersionContainer(c) );
            }
            // Set them member variable for the total number of results
            this.totalResults = this.recordContentAll.size();
        }
    }
    
    /*
        updateSearch - method to update the Search results using the searchButton on the Visualforce page
        Inputs: none, but references this.recordSearchString which is input by the Visualforce page
        Returns:
            - null PageReference (Visualforce re-renders pageBlock)
        Actions:
            - Performs a new search via performSearch()
    */
    public PageReference updateSearch() {
        // Perform the search with the current member variables which were updated by the Visualforce page
        performSearch(this.recordSearchString);

        // Return null to stay on the same page; Visualforce re-renders the list
        return null;
    }

    /*
        cleanFileType - method to return a 3-4 character filetype for a known input ContentVersion.FileType string
        Inputs:
        - String inputFileTypeString - input string in format used by ContentVersion.FileType
        - String inputFilename - input string in format used by ContentVersion.PathOnClient
        Returns: 
        - String outputFileTypeString - 3-4 character string for recognized file types
            or lower case version of inputFileTypeString for unrecognized extensions
    */
    public static String cleanFileType(String inputFileTypeString, String inputFilename) {
        // Initialize the file type string to manipulate & output
        //  By default, if a match of FileType or file extension is not made,
        //  the lower case version of the FileType will be returned
        String outputFileTypeString = inputFileTypeString.toLowerCase();
        // Convert the inputFilename string to lower case
        if (inputFilename != null) {
            inputFilename = inputFilename.toLowerCase();
        }
        
        // Set the input/output file type string mappings
        //  Identical FileType to known file extensions (e.g. bmp => bmp) are not explicitly mapped
        //  since the output file type string will be passed through from the input file type string
        Map<String, String> knownFileTypes = new Map<String, String> {
            'jpeg' => 'jpg',
            'power_point' => 'ppt', 'power_point_m' => 'pptm', 'power_point_t' => 'potx', 'power_point_x' => 'pptx',
            'excel' => 'xls', 'excel_m' => 'xlsm', 'excel_t' => 'xltx', 'excel_x' => 'xlsx',
            'word' => 'doc', 'word_m' => 'docm', 'word_t' => 'dotx', 'word_x' => 'docx',
            'text' => 'txt', 'rfc822' => 'msg',
            'visio' => 'vsd',
            'flash' => 'swf'
        };
    
        // Attempt to match the input file type string to a known value
        //  If there isn't a known value, attempt to use a file extension
        String knownFileTypeString = knownFileTypes.get(outputFileTypeString);
        if (knownFileTypeString != null) {
            outputFileTypeString = knownFileTypeString;
        } else {
            // Unknown FileType, use file extension if present
            if (inputFilename <> '' && inputFilename <> null) {
                if (inputFilename.indexOf('.') != -1) {
                    outputFileTypeString = inputFilename.substring(inputFilename.indexOf('.') + 1);
                }
            }
        }

        return outputFileTypeString;
    }

    /*
        getIconFilename - method to return the file name for a file type icon given a file type
            that has been cleaned by cleanFileType()
        Inputs:
        - String inputFileTypeString - input string in format used by ContentVersion.FileType
        Returns: 
        - String iconFilename - name of the icon file
    */
    public static String getIconFilename(String inputFileTypeString) {
        // Set the fileType to icon file base name string mappings
        Map<String, String> knownFileTypes = new Map<String, String> {
            'pdf' => 'pdf',
            'jpg' => 'image', 'jpeg' => 'image', 'bmp' => 'image', 'gif' => 'image', 'png' => 'image',
            'pack' => 'pack',
            'ppt' => 'ppt', 'pptm' => 'ppt', 'potx' => 'ppt', 'pptx' => 'ppt', 'ppsx' => 'ppt',
            'xls' => 'excel', 'xlsm' => 'excel', 'xltx' => 'excel', 'xlsx' => 'excel',
            'csv' => 'csv',
            'doc' => 'word', 'docm' => 'word', 'dotx' => 'word', 'docx' => 'word',
            'rtf' => 'rtf', 'txt' => 'txt',
            'vsd' => 'visio',
            'swf' => 'flash', 'fla' => 'flash',
            'google_document' => 'gdoc', 'google_spreadsheet' => 'gsheet', 'google_presentation' => 'gpres',
            'link' => 'link', 'htm' => 'html', 'html' => 'html', 'xml' => 'xml',
            'ai' => 'illustrator', 'psd' => 'psd', 'eps' => 'eps',
            'exe' => 'exe', 'zip' => 'zip',
            'keynote' => 'keynote', 'key' => 'keynote',
            'mp4' => 'mp4', 'm4v' => 'video', 'wmv' => 'video', 'arf' => 'webex', 'wrf' => 'webex',
            'mp3' => 'audio', 'wav' => 'audio',
            'msg' => 'unknown'
        };
    
        // Attempt to match the input file type string to a known value
        String knownIconFileBase = knownFileTypes.get(inputFileTypeString);
        String iconFilename;
        if (knownIconFileBase != null) {
            iconFilename = knownIconFileBase + '.svg';
        } else {
            iconFilename = 'unknown.svg';
        }

        return iconFilename;
    }
    
    /*
        contentAvailableCheck - method to determine if CRM Content is enabled for this user:
            1) Ensure enabled for the Org via 
                Setup | Salesforce CRM Content | Settings -> "Enable Salesforce CRM Content" is enabled
            2) Ensure enabled for the User via "Salesforce CRM Content User" feature license
        Inputs: none
        Returns: 
            - true - if CRM Content is available to the logged in user
            - false - if CRM Content is note available to the logged in user
    */
    public static Boolean contentAvailableCheck() {
        // Initialize the return variable
        Boolean contentIsAvailable = false;
        
        // Determine if Content is enabled in the org by determining if the
        //  ContentWorkspace object is available
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SobjectType findContentWorkspace = gd.get('ContentWorkspace');
        if (findContentWorkspace != null) {
            // If the ContentWorkspace object is available, Content is enabled for the Org
            // Determine if Content is available to the logged in User
            User thisUser = [SELECT Id, UserPermissionsSFContentUser
                FROM User u WHERE u.Id = :Userinfo.getUserId()
                LIMIT 1];
            if (thisUser.UserPermissionsSFContentUser == true) {
                contentIsAvailable = true;
            } else {
                contentIsAvailable = false;
            }
        } else {
            // If the ContentWorkspace object is not available, Content is not enabled
            contentIsAvailable = false;
        }
        
        // Return the content availability
        return contentIsAvailable;
    }
    
    
    /*
        postFileToFeed - Remoting method to post a piece of Content to an record's Chatter feed
            with optional comments
        Inputs:
            - ID contentId - ID of the piece of Content that should be attached to the record
            - ID parentRecordId - ID of the record to which the piece of Content should be attached
            - String commentBody - body of the Chatter post associated with the attachment
        Returns:
            - Boolean success - true if the post addition was successful / false if there is an issue posting
    */
    @RemoteAction
    global static Boolean postFileToFeed(ID contentId, ID parentRecordId, String commentBody) {
        // Build the Feed post of type ContentPost referencing the existing Content
        FeedItem contentPost = new FeedItem();
        contentPost.ParentId = parentRecordId;
        contentPost.Type = 'ContentPost';
        contentPost.RelatedRecordId = contentId;
        if (commentBody != null && commentBody != '') {
            contentPost.Body = commentBody;
        }

        // Attempt to create the Feed post
        try {
            insert contentPost;
        } catch (DmlException e) { System.debug(LoggingLevel.ERROR, e.getMessage()); return false; }

        return true;
    }   

    /*
        getObjectIconFilename - method to return the file name for an object's icon given an sObject name
        Inputs:
        - String inputObjectTypeString - input string for the sObject type
        Returns: 
        - String iconFilename - name of the icon file
    */
    public static String getObjectIconFilename(String inputObjectTypeString) {
        // Set the sObject to icon file base name string mappings
        Map<String, String> knownObjectTypes = new Map<String, String> {
            'Account' => 'account',
            'Campaign' => 'campaign',
            'Case' => 'case',
            'Contact' => 'contact',
            'Contract' => 'contract',
            'Event' => 'event',
            'Lead' => 'lead',
            'Opportunity' => 'opportunity',
            'Orders' => 'orders',
            'Product' => 'product',
            'Solution' => 'solution',
            'Task' => 'task'
        };
    
        // Attempt to match the input file type string to a known value
        String knownIconFileBase = knownObjectTypes.get(inputObjectTypeString);
        String iconFilename;
        if (knownIconFileBase != null) {
            iconFilename = knownIconFileBase + '.svg';
        } else {
            iconFilename = 'custom.svg';
        }

        return iconFilename;
    }
    
}