trigger CommunityUserCreation on Contact (before update) {

  if(!CommunityUtils.bIsRecusrsive)
        CommunityUtils.createCommunityUser(Trigger.New);
}