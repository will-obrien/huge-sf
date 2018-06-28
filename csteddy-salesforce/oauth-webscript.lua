--[[
     Retrieve a Salesforce access token and stow for future use.

--]]
Access_Token_URL =	'https://login.salesforce.com/services/oauth2/token'
Authorization_URL	= 'https://login.salesforce.com/services/oauth2/authorize'
CallBack_URL = 'https://<your subdomain>.webscript.io/salesforce-oauth'
Consumer_Key = '<your key>'	
Consumer_Secret = '<your secret>'


SF_endpoint = '/services/data/v34.0/query'
SF_metadata = '/services/data/v34.0/sobjects'

require 'csteddy/Webscript/lib.lua'


--[[
  Three legged OAuth2 flow.
  1. Get Access Code by redirecting to SF Auth URL
  2. SF callback to the redirect URI with access code as a param
  3. Get Access Token by POSTing to the SF Access URL
--]]

if request.query.code == nil then
	-- 1. Redirect the user to app Auth URL
  return 302, '', {
	Location=
	Authorization_URL..'?client_id='..Consumer_Key..
	'&redirect_uri='..lib.url_encode(CallBack_URL)..
	"&response_type=code"
	}
	end
	
-- 2. Callback gets here


-- 3.
d = {}
d['client_id']=Consumer_Key
d['client_secret']=Consumer_Secret
--d['scope']=Scope
d['code']=request.query.code
d['redirect_uri']=CallBack_URL
d['grant_type']='authorization_code'
req_headers = {}
r = lib.callout(Access_Token_URL,'POST',{},d)
log(r.content)
if (r.statuscode ~= 200) then
	return r.statuscode
end
j=json.parse(r.content)
-- Save instance_url and access_token for subsequent use in calls to SF

storage.Salesforce_instanceURL = j.instance_url
storage.Salesforce_access_token = j.access_token
