angular.module('starter.controllers', ['starter.services'])

.controller('DashCtrl', function($scope, RemoteTK) {
    $scope.taskCount = '...';
    $scope.eventcount = '...';
    $scope.eventTomorrowCount = '...';

    RemoteTK.query('Select count(Id) taskcount from Task where ActivityDate >= TODAY and IsClosed = false')
        .then(function(records) {
            $scope.taskCount = records && records.length && records[0].taskcount;
        })
    RemoteTK.query('Select count(Id) eventcount from Event where ActivityDate = TODAY')
        .then(function(records) {
            $scope.eventCount = records && records.length && records[0].eventcount;
        })
    RemoteTK.query('Select count(Id) eventcount from Event where ActivityDate = TOMORROW')
        .then(function(records) {
            $scope.eventTomorrowCount = records && records.length && records[0].eventcount;
        })

})


.controller('TasksCtrl', function($scope, RemoteTK) {
    $scope.showBulkComplete = false;

    $scope.toggleComplete = function() {
        $scope.showBulkComplete = !$scope.showBulkComplete;
    }

    $scope.edit = function(task) {
        if (sforce.one) {
            sforce.one.editRecord(task.Id);
        } else {
            location.href = '/' + task.Id + '/e';
        }
    };

    $scope.view = function(evt) {
        if (sforce.one) {
            sforce.one.navigateToSObject(evt.Id);
        } else {
            location.href = '/' + evt.Id;
        }        
    };

    $scope.complete = function(task) {
        $scope.tasks.splice($scope.tasks.indexOf(task), 1);
        RemoteTK.update('Task', task.Id, {
            'Status': 'Completed'
        });
    };

    RemoteTK.query('Select Id, Subject, ActivityDate from Task where ActivityDate = TODAY and IsClosed = false Order By ActivityDate LIMIT 20')
        .then(function(records) {
            $scope.tasks = records;
        })

})


.controller('EventsCtrl', function($scope, $stateParams, RemoteTK) {
    var activityDateFilter = $stateParams.when == 'today' ? 'TODAY' : 'TOMORROW';
    console.log($stateParams.when);
    $scope.edit = function(evt) {
        if (sforce.one) {
            sforce.one.editRecord(evt.Id);
        } else {
            location.href = '/' + evt.Id + '/e';
        }

    };
    $scope.view = function(evt) {
        if (sforce.one) {
            sforce.one.navigateToSObject(evt.Id);
        } else {
            location.href = '/' + evt.Id;
        }        
    };
    RemoteTK.query('Select Id, Subject, ActivityDateTime from Event where ActivityDate >= ' + activityDateFilter + ' Order By ActivityDateTime LIMIT 20')
        .then(function(records) {
            $scope.events = records;
        })

});
