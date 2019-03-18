public with sharing class InternalClass {

				public string thumbImgUrl{get;set;}
				public string fullImgUrl{get;set;}
					
				public InternalClass(){
								User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:Userinfo.getUserid()];
								thumbImgUrl = u.SmallPhotoUrl;
								fullImgUrl = u.FullPhotoUrl;
				}

	
}