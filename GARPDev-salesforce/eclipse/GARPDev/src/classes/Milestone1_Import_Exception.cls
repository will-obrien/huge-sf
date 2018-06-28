public with sharing class Milestone1_Import_Exception extends Exception {
    
    public static final String ERROR_NO_FILE_SELECTED = 'No import XML files selected. Please select an XML file to import.';
    public static final String ERROR_EMPTY_XML = 'The Project cannot be null. This is a critical error during import of XML. Please try exporting and re-importing.';
    public static final String ERROR_INVALID_XML = 'Import Failed -- Milestone was unable to import your file.';
    public static final String ERROR_FILESIZE_TOO_LARGE = 'The XML file is too large.';
    
}