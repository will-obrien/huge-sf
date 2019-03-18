public class SessionCacheController {

    // Inner class.
    // Used as the data type of a cache value.
    class MyData {    
        public String value { get; set; }
        public Integer counter { get; set; }
        
        public MyData(String value) {
            this.value = value;
            this.counter = 0;
        }
        
        public void inc() {
            counter++;
        }
        
        override public String toString() {
            return this.value + ':' + this.counter;
        }    
    }
    
    // Apex List.
    // Used as the data type of a cached value.
    private List<String> numbers = new List<String> { 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE' }; 
               
    // Constructor of the controller for the Visualforce page. 
    public SessionCacheController() { }
            
            
    // Adds various values to the cache.
    // This method is called when the Visualforce page loads.
    public void init() {  
        // All key values are not qualified by the namespace.partition
        // prefix because they use the default partition.
        
        // Add counter to the cache with initial value of 0
        //  or increment it if it's already there.
        if (!Cache.Session.contains('counter')) {
            Cache.Session.put('counter', 0);
        } else {
            Cache.Session.put('counter', getCounter() + 1);
        }
              
        // Add the datetime value to the cache only if it's not already there.
        if (!Cache.Session.contains('datetime')) {
            DateTime dt = DateTime.now();
            Cache.Session.put('datetime', dt);
        }
     
        // Add the custom data to the cache only if it's not already there.
        if (!Cache.Session.contains('data')) {
            Cache.Session.put('data', new MyData('Some custom value'));
        }
                
        // Add a list of number to the cache if not already there.
        if (!Cache.Session.contains('list')) {                    
            Cache.Session.put('list', numbers);
        }
                
        // Add a string value to the cache if not already there.
        if (!Cache.Session.contains('output')) {
            Cache.Session.put('output', 'Cached text value');
        }
    }
    
    // Return counter from the cache.
    public Integer getCounter() {
        return (Integer)Cache.Session.get('counter');
    }
    
    // Return datetime value from the cache.
    public String getCachedDatetime() {
        DateTime dt = (DateTime)Cache.Session.get('datetime');
        return dt != null ? dt.format() : null;
    }
    
    // Return cached value whose type is the inner class MyData.
    public String getCachedData() {
        MyData mydata = (MyData)Cache.Session.get('data');
        return mydata != null ? mydata.toString() : null;
    }
    
    // Method invoked by the Rerender button on the Visualforce page.
    // Updates the values of various cached values.
    // Increases the values of counter and the MyData counter if those 
    //   cache values are still in the cache.
    public PageReference go() {
        // Increase the cached counter value or set it to 0 
        //  if it's not cached.        
        if (Cache.Session.contains('counter')) {
            Cache.Session.put('counter', getCounter() + 1);
        } else {
            Cache.Session.put('counter', 0);
        }        
    
        // Get the custom data value from the cache.
        MyData d = (MyData)Cache.Session.get('data');
        // Only if the data is already in the cache, update it.
        if (Cache.Session.contains('data')) {
            d.inc();
            Cache.Session.put('data', d);            
        }    
        
        system.debug('*** SESSION GO *** ' + Cache.Session.get('counter'));    

        return null;
    }
    
    // Method invoked by the Remove button on the Visualforce page.
    // Removes the datetime cached value from the session cache.
    public PageReference remove() {
        Cache.Session.remove('datetime');

        return null;
    }
}