public class MyUserProfile{    
        public String name {get; set;}
        public String given_name {get; set;}
        public String family_name {get; set;}
        public String gender {get; set;}
        public String picture {get; set;}
        public AgeRangeClass age_range{get; set;}
        public ContextClass context {get; set;}
        public String updated_time {get; set;}
        public String installed {get; set;}
        public String is_verified {get; set;}
        public String link {get; set;}
        public String local {get; set;}
        public String name_format {get; set;}
        public String timezone {get; set;}
        public String third_party_id {get; set;}
        public String verified {get; set;}
        public String email_verified {get; set;}
        public String clientID {get; set;}
        public String updated_at {get; set;}
        public String user_id {get; set;}
        public String nickname {get; set;}
        public List<Identities> identities;
        public String created_at {get;set;}
        public String sub {get;set;}
        
        public MyUserProfile(String name, String given_name, String family_name, String gender, String picture, AgeRangeClass age_range,
                            ContextClass context, String updated_time, String installed, String is_verified, String link, String local,
                            String name_format, String timezone, String third_party_id, String verified, String email_verified, String clientID,
                            String updated_at, String user_id, String nickname, String created_at, String sub, List<Identities> identities){
            this.name = name;
            this.given_name = given_name;
            this.family_name = family_name;
            this.gender = gender;
            this.picture = picture;
            this.age_range = age_range;
            this.context = context;
            this.updated_time = updated_time;
            this.installed = installed;
            this.is_verified = is_verified;
            this.link = link;
            this.local = local;
            this.name_format = name_format;
            this.timezone = timezone;
            this.third_party_id = third_party_id;
            this.verified = verified;
            this.email_verified = email_verified;
            this.clientID = clientID;
            this.updated_at = updated_at;
            this.user_id = user_id;
            this.nickname = nickname;
            this.identities = identities;
            this.created_at = created_at;
            this.sub = sub;            
        }
        
        public class AgeRangeClass{    
            public String min {get;set;}            
            public AgeRangeClass(String min){
                this.min = min;
            }    
        }
        
        public class ContextClass{        
            public String id {get;set;}
            public MutualLikesClass mutual_likes {get;set;}
            public ContextClass(MutualLikesClass mutual_likes){
                this.mutual_likes = mutual_likes;            
            }
        }
        
        public class MutualLikesClass{        
            public String id {get;set;}
            public String[] data {get;set;}
            public SummaryClass summary {get; set;}        
            public MutualLikesClass(String id, String[] data, SummaryClass summary){
                this.id = id;
                this.data = data;
                this.summary = summary;
            }
        }        
        
        public class DataClass{            
            public String[] data {get;set;}        
            public DataClass(String[] data){
                this.data = data;
            }        
        }
        
        public class SummaryClass{
            public String total_count {get;set;}
            public SummaryClass(String total_count){
                this.total_count = total_count;
            }
        
        }
        
        public class Identities {
            public String access_token;
            public String provider;
            public String user_id;
            public String connection;
            public Boolean isSocial;
        }
}