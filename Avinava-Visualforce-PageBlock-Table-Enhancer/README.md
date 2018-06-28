PageBlock Table Enhancer
=========

A visualforce component that adds additional functionality to your existing or new standard pageblock table components by using just one line of code

Few features of the PageBlock Table Enhancer component
-

* Uses Jquery Table Sorter to do client side coding.
* Pagination
* Option to provide available page sizes
* Option to select default page size on page load

Ajax/Rerender support
-
This version brings in support for rendering, the earlier version wasn't able to handle this. So incase you are rerendering your table or the parent components, you can call the "initPageBlockTableEnhancer()" method from "oncomplete" even of your commandButtons/actionFunctions/actionSupport/commandLink .
```
<apex:commandButton value="Rerender" reRender="mid" oncomplete="initPageBlockTableEnhancer()"/>
```

Version
-

2.2


Installation
--------------

* Install the Package from https://login.salesforce.com/packaging/installPackage.apexp?p0=04t90000000MbZI

List of Parameters
-

* targetPbTableIds : comma-separated Ids of the target Pageblock tables
* paginate : Assign true if you want to use the pagination feature,default value is true.
* pageSizeOptions : A comma seperated list of integer values that will displayed as dropdown for page size
* defaultPageSize : Default page size that needs to be selected (at page load).

Usage
-
```
   <c:PageBlockTableEnhancer targetPbTableIds="mid,mid2" paginate="true" defaultPageSize="5" pageSizeOptions="5,10,20,30,40,50,100"/>    
   <apex:pageBlock >   
     <apex:pageBlockTable value="{!accounts}" var="acc" id="mid">   
      <apex:column value="{!acc.Name}"/>   
     </apex:pageBlockTable>    
     <apex:pageBlockTable value="{!accounts}" var="acc" id="mid2">   
      <apex:column value="{!acc.Name}"/>   
     </apex:pageBlockTable>     
   </apex:pageBlock>   
``` 
Demo
-
http://blogforce9dev-developer-edition.ap1.force.com/PageBlockTableEnhancerDemo
  
    
