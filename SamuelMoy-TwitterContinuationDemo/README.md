TwitterContinuationDemo
=======================
This demo consists of a Visualforce Page where you can enter some twitter search criteria en get respons from the Twitter Search API.
The logic behind it is done with the Continuation Class in an Apex Controller

It looks like this ![Demo Screenshot](/readme/vf_page.PNG?raw=true)

Steps to make it work

1. Create Twitter Account
2. Create Twitter app add https://apps.twitter.com/
3. Get your Consumer Key and Consumer Secret. 
Screenshot:
![TwitterKeys Screenshot](/readme/twitter_access.PNG?raw=true)
4.Copy the Apex Classes and the Visualforce page into your own developer org
5.Enter your Consumer Key and Secret to the properties at the top of the Apex Class TwitterController
6.Add https://api.twitter.com/ to your Remote Site Settings in your org
Screenshot:
![RemoteSite Screenshot](/readme/remotesite.PNG?raw=true)
7.Add /apex/TwitterHashtag to your base URL and enjoy



