global class GroupFeedController{
    
    // Declare and assign values to strings to use as method parameters.
    private static String communityId = null;
    private static String userId = 'me';
    
    // Holds the ID of the selected group.
    // Pass this property to getFeedItemsFromFeed to get the group's feed.
    global String groupId { get; set; }
 
    // Get the IDs and names for all of the groups 
    // the logged-in user is a member of. Add them to
    // a List of SelectionOption objects. This List populates
    // the drop-down menu in the GroupFeed custom component.
    global static List<SelectOption> getGroupOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
        // Adds a blank option to display when the page loads.
        options.add(new SelectOption('', ''));
        
        // Declare and assign values to strings to use as method parameters. 
        Integer page = 0;        
        Integer pageSize = 100;
        
        // Use Chatter in Apex to get the names and IDs of every group
        // the logged-in user is a member of.
        // Chatter in Apex classes are in the ConnectApi namespace.
        // communityId -- a community ID or null.
        // userId -- the user ID or the keyword 'me' to specify the logged-in user.
        // page -- the page number to return.
        // pageSize -- the number of items on the page.
        ConnectApi.UserGroupPage groupPage = ConnectApi.ChatterUsers.getGroups(communityId, userId, page, pageSize);
        
        // The total number of groups the logged-in user is a member of.
        Integer total = groupPage.total;
        
        // Loop through all the groups and add each group's id and name
        // to the list of selection options.
        while (page * pageSize < total) {
            // groupPage.groups is a List of ConnectApi.ChatterGroupSummary objects.
            // ChatterGroupSummary is a subclass of ChatterGroup.
            // For each ChatterGroup object in the List...
            for (ConnectApi.ChatterGroup grp : groupPage.groups) {
                // Add the group's ID and name to the list of selection options.
                options.add(new SelectOption(grp.id, grp.name));
            }
           
            page++;
            
            if (page * pageSize < total) {
                // Get the next page of groups.
                groupPage = ConnectApi.ChatterUsers.getGroups(communityId, userId, page, pageSize);
            }
        }
        
        // Return the list of selection options.
        return options;
    }
    
    // Get the feed items that make up a group's feed.
    global List<ConnectApi.FeedItem> getFeedItems() {
        if (String.isEmpty(groupId)) { return null; }
        // To get the feed for a group, use the Record feed type and pass a group ID.
        // getFeedItemsFromFeed returns a ConnectApi.FeedItemPage class.
        // To get the List of ConnectApi.FeedItem objects,
        // add the .items property to the call.
        return ConnectApi.ChatterFeeds.getFeedItemsFromFeed(communityId, ConnectApi.FeedType.Record, groupId).items;
    }
    
    public PageReference choose() {
        return null;
    }
    
}