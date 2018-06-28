global class URLRewriterClass implements Site.UrlRewriter { 
  String SEARCH_PAGE = '/search';
  String PROFILE_PAGE = '/profile';
  String PRODUCT_PAGE = '/product';

  String SEARCH_VF_PAGE = '/SmartLife_Search';
  String PROFILE_VF_PAGE = '/SmartLife_Profile';
  String PRODUCT_VF_PAGE = '/SmartLife_Product';

 global PageReference mapRequestUrl(PageReference myFriendlyUrl){
    String url = myFriendlyUrl.getUrl();
    System.debug('***** FRIENDLY URL ***** ' + url);

    if (url.equals(SEARCH_PAGE)){
        return new PageReference(SEARCH_VF_PAGE);
    }else if (url.equals(PROFILE_PAGE)){
        return new PageReference(PROFILE_VF_PAGE);
    }else if (url.equals(PRODUCT_PAGE)){
        String id = url.substring(PRODUCT_PAGE.length(), url.length());
        System.debug('UrlRewriterClass.mapRequestUrl: id : ' + id);
        return new PageReference(PRODUCT_VF_PAGE);
    }
    return null;
  }

  global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls){
      return null;
  }
}