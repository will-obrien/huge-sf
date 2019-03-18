@RestResource(urlMapping='/Account/*')
global with sharing class MyRestResource {
  
  @HttpGet
    global static String doGet() {
      return null; 
    }
}