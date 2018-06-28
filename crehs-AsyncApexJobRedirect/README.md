#Async Apex Job Redirect Page Parameters
keep user on intermediate Visualforce page until Async Apex Job is completed before redirecting to record in order to prevent row lock errors.

Param  | Description | Required
------ | ----------- | --------
pid | apex job process id | true
redirect | full url or id to redirect to | true
polling |turns polling off; used for debugging purposes | false

#Example URL

https://*salesforce instance*/apex/redirect?pid=707m000000M82NgAAJ&redirect=a18j0000000DZ5h
