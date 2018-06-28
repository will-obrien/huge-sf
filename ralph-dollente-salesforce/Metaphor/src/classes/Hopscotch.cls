public class Hopscotch{

    public Integer totalCount;
    public Integer returnCount;
    public Integer pageNumber;
    public List<Data> data;
    public Boolean isSuccess;
    public Integer errorCode;
    public String errorMsg;
    //public Object objectId;
    public String currentTime;

    public class DisplayImage {
        public Integer id;
        public Integer channelID;
        public String name;
        public String sourceFilename;
        public String path;
        public Integer assetTypeID;
        public String caption;
        //public Object credit;
        public Integer originalHeight;
        public Integer originalWidth;
        public Double aspectRatio;
        public String tags;
        public String createdDate;
        public String modifiedDate;
        public Integer createdByID;
        public Integer modifiedByID;
        public String createdByName;
        public String modifiedByName;
        public Boolean selected;
    }

    public class DetailedImage2 {
        public Boolean isFullyLoaded;
        public String name;
        public Boolean selected;
        public Integer id;
        public Integer percentLoaded;
        public String path;
        public Double aspectRatio;
        public Integer originalHeight;
        public Integer originalWidth;
        public String sourceFilename;
        public Integer channelID;
        public Integer modifiedByID;
        public String modifiedDate;
        public String modifiedByName;
        public Integer createdByID;
        public String createdDate;
        public String createdByName;
        public Integer assetTypeID;
    }

    public class Data {
        public Integer modelDefinitionID;
        public Integer workflowStatusID;
        public String title;
        public String description;
        public DisplayImage displayImage;
        public DisplayImage detailedImage;
        public String startDate;
        //public Object endDate;
        public List<Integer> targetIDs;
        public List<Integer> destinationIDs;
        public String category;
        //public Object source;
        public DetailedImage2 detailedImage2;
        public Boolean useTemplate;
        public Integer id;
        public Integer categoryId;
        public Integer channelID;
        public String templateHTML;
        public String detailsHTML;
        public String createdDate;
        public String modifiedDate;
        public String createdByName;
        public String modifiedByName;
        public String url;
        public Boolean noDetail;
        public Boolean isWebview;
        //public Object eventStartTime;
        //public Object eventEndTime;
    }

    public class DisplayImage_Y {
        public Boolean isFullyLoaded;
        public String name;
        public Boolean selected;
        public Integer id;
        public Integer percentLoaded;
        public String path;
        public Integer aspectRatio;
        public Integer originalHeight;
        public Integer originalWidth;
        public String sourceFilename;
        public Integer channelID;
        public Integer modifiedByID;
        public String modifiedDate;
        public String modifiedByName;
        public Integer createdByID;
        public String createdDate;
        public String createdByName;
        public Integer assetTypeID;
    }

    public class DetailedImage2_Z {
        public Integer id;
        public Integer channelID;
        public String name;
        public String sourceFilename;
        public String path;
        public Integer assetTypeID;
        public String caption;
        //public Object credit;
        public Integer originalHeight;
        public Integer originalWidth;
        public Integer aspectRatio;
        public String tags;
        public String createdDate;
        public String modifiedDate;
        public Integer createdByID;
        public Integer modifiedByID;
        public String createdByName;
        public String modifiedByName;
        public Boolean selected;
    }

    public class DisplayImage_Z {
    
    }
}