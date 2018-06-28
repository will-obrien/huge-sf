angular.module('starter.services', [])

/**
 * A simple example service that returns some data.
 */
.service('RemoteTK', function($q) {
  //get remotetk client
  var _remoteTKClient = new remotetk.Client();   
  this.query = function(queryString) {
    var deferred = $q.defer();
    //Call RemoteTK's query API  
    _remoteTKClient.query(queryString, 
      function(response) {        
        deferred.resolve(response.records);//return result as promised earlier
      },
      function(error) {
        alert(JSON.stringify(error));
        deferred.reject(error);//send error as promised earlier
      });
    //promise that we will return something (asynchoronusly in the future)
    return deferred.promise;
  };

  this.update = function(objtype, id, fields) {
    var deferred = $q.defer();
    //Call RemoteTK's query API  
    _remoteTKClient.update(objtype, id, fields, 
      function(response) {        
        console.log(response);
        deferred.resolve('done');//return result as promised earlier
      },
      function(error) {
        alert(JSON.stringify(error));
        deferred.reject(error);//send error as promised earlier
      });
    //promise that we will return something (asynchoronusly in the future)
    return deferred.promise;
  };

})


