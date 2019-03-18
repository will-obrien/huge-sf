public class OdysseyController{

    public List<DataClass> featureList {get; set;}
    public List<DataClass> musicList {get; set;}
    public List<DataClass> movieList {get; set;}
    public List<DataClass> tvshowList {get; set;}
    public List<DataClass> gameList {get; set;}
    public List<DataClass> detailInfo {get; set;}
    
    public DataClass info {get; set;}
    
    
    public String user_id {get;set;}
    
    public String selectedItem {get; set;}
    public String currentId {get; set;}
    public String category {get; set;}
    
    public Hopscotch hopscotch {get; set;}
    
    public OdysseyController(){
         user_id = ApexPages.currentPage().getParameters().get('user_id');         
         System.debug('*** USERID *** ' + user_id);
    }
    
    
    public class DataClass{
        public Integer id {get; set;}
        public String title {get; set;}
        public String description {get; set;}
        public DisplayImageClass displayImage {get; set;}
        public String category {get; set;}
        public Integer categoryId {get; set;}
        public Integer channelID {get; set;}
        public String url {get; set;}
        public DetailedImage2Class detailedImage2 {get; set;}
        public String createdDate {get; set;}
        public String modifiedDate {get; set;}
        public String createdByName {get; set;}
        public String modifiedByName {get; set;}
        public String[] ratings {get; set;}
        public String winner {get; set;}
        public DisplayImageClass detailedImage {get; set;}
        
        public DataClass(Integer id, String title, String winner, String description, DisplayImageClass displayImage, 
                         String category, Integer categoryId, Integer channelID, String url, DetailedImage2Class detailedImage2, 
                         String createdDate, String modifiedDate, String createdByName, String modifiedByName, 
                         String[] ratings, DisplayImageClass detailedImage){

            this.id = id;
            this.title = title;
            this.winner = winner;
            this.description = description;
            this.displayImage = displayImage;
            this.category = category;
            this.categoryId = categoryId;
            this.channelID = channelID;
            this.url = url;
            this.detailedImage2 = detailedImage2;
            this.createdDate = createdDate;
            this.modifiedDate = modifiedDate;
            this.createdByName = createdByName;
            this.modifiedByName = modifiedByName;    
            this.ratings = ratings;
            this.detailedImage = detailedImage;
        }
    }
    
    public class DetailedImage2Class{
        public Integer id {get; set;}
        public Integer channelID {get; set;}
        public String name {get; set;}
        public String sourceFilename {get; set;}
        public String path {get; set;}
        public Integer assetTypeID {get; set;}
        public Integer originalHeight {get; set;}
        public Integer originalWidth {get; set;}
        public Boolean selected {get; set;}
        
        public DetailedImage2Class(Integer id, Integer channelID, String name, String sourceFilename, String path,
                                   Integer assetTypeID, Integer originalHeight, Integer originalWidth,
                                    Boolean selected){
            this.id = id;
            this.channelID = channelID;
            this.name = name;
            this.sourceFilename = sourceFilename;
            this.path = path;
            this.assetTypeID = assetTypeID;
            this.originalHeight = originalHeight;
            this.originalWidth = originalWidth;
            this.selected = selected;        
        }
    
    }
    
    public class DisplayImageClass{    
        public Integer id {get; set;}
        public Integer channelID {get; set;}
        public String name {get; set;}
        public String sourceFilename {get; set;}
        public String path {get; set;}
        public Integer assetTypeID {get; set;}
        public String caption {get; set;}
        public Integer originalHeight {get; set;}
        public Integer originalWidth {get; set;}
        public Boolean selected {get; set;}
        
        public DisplayImageClass(Integer id, Integer channelID, String name, String sourceFilename, String path, Integer assetTypeID, 
                            String caption, Integer originalHeight, Integer originalWidth, Boolean selected){
            this.id = id;
            this.channelID = channelID;
            this.sourceFilename = sourceFilename;
            this.path = path;
            this.assetTypeID = assetTypeID;
            this.caption = caption;
            this.originalHeight = originalHeight;
            this.originalWidth = originalWidth;
            this.selected = selected;        
        }
    }
    
    private List<String> getRatings(String category, String source){        
        List<String> myRatings = new List<String>{'#FFF','#FFF','#FFF','#FFF','#FFF'};
        Integer counter = 0;
                
        if (category.equals('game')){
            String c = source.subStringAfter('|');
            String d = c.subStringAfter('|');
                     
            if (d.contains('|')){
                d = d.subStringBefore('|');
            }
            
            try{
                counter = Integer.valueOf(d.trim());                
            }catch(Exception e){
                counter = 0;
                system.debug('*** EXCEPTION *** ' + e.getMessage());
            }       
        }else if (category.equals('movie')){
            system.debug('*** DESCRIPTION *** ' + source);            
            String c = source.subStringAfter('|');
            String d = c.subStringBefore('|');

            try{
                counter = Integer.valueOf(d.trim());                
            }catch(Exception e){
                counter = 0;
                system.debug('*** EXCEPTION *** ' + e.getMessage());
            }       
        }else if (category.equals('music')){
            system.debug('*** DESCRIPTION *** ' + source);
            String c = source.subStringAfter('|');            
            system.debug('*** AFTER *** ' + c);
            String d = c.subStringAfter('|');
            system.debug('*** AFTER *** ' + d);
            String e1 = d.subStringBefore('|');
            system.debug('*** BEFORE *** ' + e1);
            
            try{
                counter = Integer.valueOf(e1.trim());                
            }catch(Exception e){
                counter = 0;
                system.debug('*** EXCEPTION *** ' + e.getMessage());
            }       
        }
        
        for (Integer i=0; i<= counter-1; i++) {
            myRatings[i] = '#000';
        }             
        return myRatings;    
    }
    
    public PageReference redirectToDetails(){    
        System.debug('*** GET DETAILS *** ' + selectedItem); 
        System.debug('*** CURRENT ID *** ' + currentId);
        System.debug('*** CATEGORY *** ' + category);
                 
        PageReference pageRef = new PageReference('/apex/details');        
        selectedItem = selectedItem.replaceAll('.jpg', '');        
        pageRef.getParameters().put('user_id', user_id);
        pageRef.getParameters().put('img', selectedItem);
        pageRef.getParameters().put('id', currentId);
        pageRef.getParameters().put('category', category);
        pageRef.setRedirect(true);
        return pageRef;        
    }
    
    private Boolean setHopscotchPayLoad(){
        try{
            initList();
            hopscotch = new CilantroGatewayAccess().getHopscotchPayLoad('perks');                    
        }catch(Exception e){
            System.debug('*** SET HOPSCOTCH PAYLOAD *** ' + e.getMessage());
            return false;
        }
        return true;
    }
    
    
    public void getDetailInfo(){
    
        System.debug('*** CURRENT ID *** ' + ApexPages.currentPage().getParameters().get('id'));     
        System.debug('*** IMG *** ' + ApexPages.currentPage().getParameters().get('img'));
        System.debug('*** USERID *** ' + ApexPages.currentPage().getParameters().get('user_id'));
        System.debug('*** CATEGORY *** ' + ApexPages.currentPage().getParameters().get('category'));
        
        String selectedCategory = ApexPages.currentPage().getParameters().get('category').toLowerCase();
        String currentId = ApexPages.currentPage().getParameters().get('id');
        
        if (!setHopscotchPayLoad()){
            System.debug('*** FAILED *** ');
            return;        
        }
        
        String description = '';
        
        if (detailInfo == null)
            detailInfo = new List<DataClass>();
            
        for(Hopscotch.data d :hopscotch.data){        
            if (d.id == Integer.valueOf(currentId)){
                System.debug('*** CURRENT ID *** ' + d.id);
                System.debug('*** TITLE *** ' + d.title);               
                
                if (d.category.tolowercase().equals('feature')){
                    description = d.description.substringAfter('|'); 
                    
                    if (d.displayImage == null){    
                        System.debug('*** DETAILED IMAGE *** ');  
                        info = new DataClass(d.id, d.title, '', description, new DisplayImageClass(d.detailedImage.id, d.detailedImage.channelID, d.detailedImage.name, d.detailedImage.sourceFilename, d.detailedImage.path, 
                                            d.detailedImage.assetTypeID, d.detailedImage.caption, d.detailedImage.originalHeight, d.detailedImage.originalWidth, 
                                            d.detailedImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                            new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, 
                                            d.createdByName, d.modifiedByName, 
                                            null, null);
                    }else{
                        System.debug('*** DISPLAY IMAGE *** '); 
                        
                        info = new DataClass(d.id, d.title, '', description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                               d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                               d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                               new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, 
                                                                                               d.createdByName, d.modifiedByName, 
                                                                                               null, null);
                    }  
                }
                          
                          
                if (d.category.tolowercase().equals('movie')){ 
                    description = d.description.substringBefore('|');                                   
                    info = new DataClass(d.id, d.title, '', description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                               d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                               d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                               new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, 
                                                                                               d.createdByName, d.modifiedByName, 
                                                                                               null, null);
                }          
                          
                if (d.category.tolowercase().equals('music')){ 
                    description = d.description.substringBefore('|');                                   
                    info = new DataClass(d.id, d.title, '', d.title, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                               d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                               d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                               new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, 
                                                                                               d.createdByName, d.modifiedByName, 
                                                                                               null, null);
                }                                                                        
                                                                                       
                if (d.category.tolowercase().equals('game')){ 
                    description = d.description.substringAfter('|');
                    description = description.substringBefore('|');                                                       
                    info = new DataClass(d.id, d.title, '', description, new DisplayImageClass(d.detailedImage.id, d.detailedImage.channelID, d.detailedImage.name, d.detailedImage.sourceFilename, d.detailedImage.path, 
                                                                                           d.detailedImage.assetTypeID, d.detailedImage.caption, d.detailedImage.originalHeight, d.detailedImage.originalWidth, 
                                                                                           d.detailedImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                           new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, 
                                                                                           d.createdByName, d.modifiedByName, 
                                                                                           null, null);
                }                                                                                                          
                                                                                                      
                //break the loop if id found 
                break; 
            }
        }
        
        System.debug('*** DETAIL INFO *** ' + detailInfo);
        
    }
    
    private void initList(){
        featureList = new List<DataClass>();
        musicList = new List<DataClass>();
        movieList = new List<DataClass>();
        tvshowList = new List<DataClass>();
        gameList = new List<DataClass>();
        detailInfo = new List<DataClass>();       
    }
    
    
    public void getSelectedMenuItem(){
        
        String selectedCategory = 'feature';
        
        if (ApexPages.currentPage().getParameters().get('category') != null){      
            selectedCategory = ApexPages.currentPage().getParameters().get('category').toLowerCase();  
        }      
        
        String s1 = '';
        String s2 = '';
        String winners = '';
        String imagePath = '';
        
        setHopscotchPayLoad();
                
        if (selectedCategory == null)
            return;
        
        List<String>  myRatings = new List<String>{'#FFF','#FFF','#FFF','#FFF','#FFF'};        
        
        for(Hopscotch.data d :hopscotch.data){
            winners = '';
             
            if (selectedCategory.equals(d.category.tolowercase()) && d.category.tolowercase().equals('music')){
                myRatings = getRatings(d.category.tolowercase(), d.description); 

                if (d.description != null && d.description.length() > 38){
                    d.description = d.description.subString(0, 38) + '...';                      
                }
                              
                musicList.add(new DataClass(d.id, d.title, '', d.description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                   d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                   d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                   new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, 
                                                                                   d.createdByName, d.modifiedByName, 
                                                                                   myRatings, 
                                                                                   new DisplayImageClass(0, 0, '', '', d.displayImage.path,  0, '', 0, 0, false)                                                                                   
                                                                                   ));
                                                                                   
            }else if (selectedCategory.equals(d.category.tolowercase()) && d.category.tolowercase().equals('feature')){
              myRatings = getRatings(d.category.tolowercase(), d.description);                             
              winners = d.description.substringBefore('|');
              s1 = d.description.substringAfter('|');
              s2 = s1.subString(0, 40) + '...';
              
              featureList.add(new DataClass(d.id, d.title, winners, s1, new DisplayImageClass(0, 0, '', '', '', 0, '', 0, 0, false), d.category, d.categoryId,  
                                                                                   d.channelID, d.url, new DetailedImage2Class(d.detailedImage2.id, d.detailedImage2.channelID, d.detailedImage2.name,
                                                                                   d.detailedImage2.sourceFilename, d.detailedImage2.path, d.detailedImage2.assetTypeID, d.detailedImage2.originalHeight,
                                                                                   d.detailedImage2.originalWidth, d.detailedImage2.selected), 
                                                                                   d.createdDate, d.modifiedDate, d.createdByName, 
                                                                                   d.modifiedByName, 
                                                                                   myRatings,
                                                                                   new DisplayImageClass(d.detailedImage.id, d.detailedImage.channelID, d.detailedImage.name, d.detailedImage.sourceFilename, d.detailedImage.path, 
                                                                                   d.detailedImage.assetTypeID, '', d.detailedImage.originalHeight, d.detailedImage.originalWidth, 
                                                                                   d.detailedImage.selected)
                                                                                   ));    
                                                                                                                             
            }else if (selectedCategory.equals(d.category.tolowercase()) && d.category.tolowercase().equals('movie')){
                myRatings = getRatings(d.category.tolowercase(), d.description); 
                imagePath = (d.detailedImage != null? d.detailedImage.path : d.displayImage.path);                
                movieList.add(new DataClass(d.id, d.title, '', d.description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                              d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                              d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                              new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, 
                                                                                              d.modifiedDate, d.createdByName, d.modifiedByName,
                                                                                              myRatings,
                                                                                              new DisplayImageClass(0, 0, '', '', imagePath,  0, '', 0, 0, false)
                                                                                              ));                                                                                                                                                                                 
            }else if (selectedCategory.equals(d.category.tolowercase()) && d.category.tolowercase().equals('game')){
                s1 = d.description.substring(0, 50)+ '...';
                myRatings = getRatings(d.category.tolowercase(), d.description);                 
                gameList.add(new DataClass(d.id, d.title, '', s1, new DisplayImageClass(d.detailedImage.id, d.detailedImage.channelID, d.detailedImage.name, d.detailedImage.sourceFilename, d.detailedImage.path, 
                                                                                  d.detailedImage.assetTypeID, d.detailedImage.caption, d.detailedImage.originalHeight, d.detailedImage.originalWidth, false), 
                                                                                  d.category, d.categoryId, d.channelID, d.url, 
                                                                                  new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, d.createdByName, d.modifiedByName,
                                                                                  myRatings, 
                                                                                  new DisplayImageClass(0, 0, '', '', d.detailedImage.path,  0, '', 0, 0, false)                                                                                  
                                                                                  )); 
                                                                                                                                                                   
            }else if (selectedCategory.equals(d.category.tolowercase()) && d.category.tolowercase().equals('tv show')){
                myRatings = getRatings(d.category.tolowercase(), d.description); 
                tvshowList.add(new DataClass(d.id, d.title, '', d.description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                               d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                               d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                               new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, d.createdByName, d.modifiedByName,
                                                                                               myRatings, null));
            }        
        } //for
        
        
        system.debug('*** MOVIE LIST *** ' + movieList);
        
    }
    

    public void getPerks(){

        String s1 = '';
        String s2 = '';
        String winners = '';
        
        if(!setHopscotchPayLoad()){
            return;
        }
        
        List<String>  myRatings = new List<String>{'#FFF','#FFF','#FFF','#FFF','#FFF'};
        
        for(Hopscotch.data d :hopscotch.data){
            winners = '';
                    
            if (d.category.tolowercase().equals('music')){
                myRatings = getRatings(d.category.tolowercase(), d.description); 

                if (d.description != null && d.description.length() > 38){
                    d.description = d.description.subString(0, 38) + '...';                      
                }
                              
                musicList.add(new DataClass(d.id, d.title, '', d.description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                   d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                   d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                   new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, 
                                                                                   d.createdByName, d.modifiedByName, 
                                                                                   myRatings, null));
            }else if (d.category.tolowercase().equals('feature')){
              myRatings = getRatings(d.category.tolowercase(), d.description);                             
              winners = d.description.substringBefore('|');
              s1 = d.description.substringAfter('|');
              s2 = s1.subString(0, 40) + '...';
              featureList.add(new DataClass(d.id, d.title, winners, s1, new DisplayImageClass(0, 0, '', '', '', 0, '', 0, 0, false), d.category, d.categoryId,  
                                                                                   d.channelID, d.url, new DetailedImage2Class(d.detailedImage2.id, d.detailedImage2.channelID, d.detailedImage2.name,
                                                                                   d.detailedImage2.sourceFilename, d.detailedImage2.path, d.detailedImage2.assetTypeID, d.detailedImage2.originalHeight,
                                                                                   d.detailedImage2.originalWidth, d.detailedImage2.selected), 
                                                                                   d.createdDate, d.modifiedDate, d.createdByName, 
                                                                                   d.modifiedByName, 
                                                                                   myRatings, null));                                              
            }else if (d.category.tolowercase().equals('movie')){
                myRatings = getRatings(d.category.tolowercase(), d.description); 
                movieList.add(new DataClass(d.id, d.title, '', d.description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                              d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                              d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                              new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, 
                                                                                              d.modifiedDate, d.createdByName, d.modifiedByName,
                                                                                              myRatings, null));                                                                                              
            }else if (d.category.tolowercase().equals('game')){
                s1 = d.description.substring(0, 50)+ '...';
                myRatings = getRatings(d.category.tolowercase(), d.description); 
                gameList.add(new DataClass(d.id, d.title, '', s1, new DisplayImageClass(d.detailedImage.id, d.detailedImage.channelID, d.detailedImage.name, d.detailedImage.sourceFilename, d.detailedImage.path, 
                                                                                  d.detailedImage.assetTypeID, d.detailedImage.caption, d.detailedImage.originalHeight, d.detailedImage.originalWidth, false), 
                                                                                  d.category, d.categoryId, d.channelID, d.url, 
                                                                                  new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, d.createdByName, d.modifiedByName,
                                                                                  myRatings, null));                                                                                  
            }else if (d.category.tolowercase().equals('tv show')){
                myRatings = getRatings(d.category.tolowercase(), d.description); 
                tvshowList.add(new DataClass(d.id, d.title, '', d.description, new DisplayImageClass(d.displayImage.id, d.displayImage.channelID, d.displayImage.name, d.displayImage.sourceFilename, d.displayImage.path, 
                                                                                               d.displayImage.assetTypeID, d.displayImage.caption, d.displayImage.originalHeight, d.displayImage.originalWidth, 
                                                                                               d.displayImage.selected), d.category, d.categoryId, d.channelID, d.url, 
                                                                                               new DetailedImage2Class(0, 0, '', '', '', 0, 0, 0, false), d.createdDate, d.modifiedDate, d.createdByName, d.modifiedByName,
                                                                                               myRatings, null));
            }        
        }    
    }
}