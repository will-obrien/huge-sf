--[[
		This script is designed to be the endpoint for the Salesforce
		SOAP Outbound Messaging. The Salesforce messages are part of the
	  workflow functionality which can be customised to limit the
		conditions under which a notification is sent as well as the 
		subset of SObject fields that is sent as part of the message.
		Salesforce will only send the field if it has a value. It is
		also possible that up to 100 notifications (for separate SObjects)
		to be sent in a single message.

		You can configure the Outbound Message to include a Session Id,
		which is a token allowing the receiver (in this case, this script)
		to make one or more authenticated callbacks to Salesforce.
--]]
require 'csteddy/Webscript/lib.lua'


log(request.body)
-- Get Session Id <SessionId>
SessionId = request.body:match'%s<SessionId>(.-)</SessionId>'
--log(SessionId)
-- Get organization Id <OrganizationId>
OrganizationId = request.body:match'%s<OrganizationId>(.-)</OrganizationId>'
--log(OrganizationId)
-- Convert to shortform Id
OrganizationId = string.sub(OrganizationId, 1, 15)
--log(OrganizationId)
-- Get EnterpriseUrl <EnterpriseUrl>
EnterpriseUrl = request.body:match'%s<EnterpriseUrl>(.-)</EnterpriseUrl>'
--log(EnterpriseUrl)
-- Trim off Org id
ep = EnterpriseUrl:gsub(OrganizationId,'')
-- https://greenworx.my.salesforce.com/services/Soap/c/31.0/00DA0000000IOlI
-- derive the SF URL from the <EnterpriseUrl>
instanceURL = 'https://greenworx.my.salesforce.com'
-- convert SOAP endpoint to REST endpoint
instanceURL = ep:gsub('/Soap/c/','/data/v')
--log(instanceURL)
-- get SF Object type
--sObject = request.body:match'%s<sObject xsi:type="sf:(.-)"'
--log(sObject)


function callout(req_url,req_method,req_params,req_data)

return http.request {
	      url = req_url, method = req_method, 
	      headers = req_headers, 
	      params = req_params,
		    data = req_data
        }

end

req_headers = {}
-- set the Session Id token in the headers
req_headers["Authorization"] = "OAuth "..SessionId
log(req_headers["Authorization"])
req_headers["Content-Type"] = "application/json"
--p={q = "SELECT Name, Id from "..sObject.." LIMIT 1" }

-- Process each object in outbound message
-- Usually there is only 1 per outbound SOAP message
for sObject,junk,Id in request.body:gmatch'<sObject xsi:type="sf:(.-)"(.-)<sf:Id>(.-)</sf:Id>' do

--r = callout(instanceURL..'query','GET',p,{})
r = callout(instanceURL..'sobjects/'..sObject..'/'..Id,'GET',{},{})
--r = callout('http://requestb.in/wnqwafwn','GET',p,{})
log(r.content)
parsed = json.parse(r.content)
patch = {}
patch.Name = '37 Carr St.'
log(json.stringify(patch))
if parsed.Id == "a0nF0000002zweMIAQ" and parsed.LastModifiedById ~= "005F0000002E6SoIAK" then
	r = callout(instanceURL..'sobjects/'..sObject..'/'..Id,'PATCH',{},json.stringify(patch))
	log(r.statuscode)
	log(r.content)
end
end



-- Setup a SOAP XML acknowledgement to make SF happy
-- (If it doesn't receive one then the message will stay in the SF
--	outbound message and be retried, possibly indefinitely)
body = [[
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <notificationsResponse xmlns="http://soap.sforce.com/2005/09/outbound">
      <Ack>true</Ack>
    </notificationsResponse>
  </soapenv:Body>
</soapenv:Envelope>
]]
return 200,body,{['Content-Type']='text/xml'}
