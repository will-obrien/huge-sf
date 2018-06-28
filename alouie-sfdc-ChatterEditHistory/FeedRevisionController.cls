/*
Copyright (c) 2015, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Controller for a VisualForce page that displays the editing history for a Chatter thread.
 * Admins and other interested parties can use this page instead of doing a SOQL query on the
 * FeedRevision sObject.
 *
 * See https://github.com/alouie-sfdc/ChatterEditHistory for more information.
 * 
 * @author arthur.louie
 */


public with sharing class FeedRevisionController {

    public String feedItemId { get; set; }
    public String url {
        get;
        set {
            url = value;
            
            // Parse the feed item ID from the URL. The key prefix for feed items is 0D5.
            
            Pattern p = Pattern.compile('.*(0D5[A-Za-z0-9]{12,15}).*');
            Matcher matcher = p.matcher(value);

            if (matcher.matches()) {
                feedItemId = matcher.group(1);
            }
            else {
                feedItemId = null;
            }
       }
    }

    private FeedItemAndRevisions feedItemAndRevisionInfo;
    private List<CommentAndRevisions> commentsAndRevisions;

    public FeedItemAndRevisions getFeedItemAndRevisions() {

        feedItemAndRevisionInfo = null;
        
        if (feedItemId != null) {

            List<FeedItem> feedItems = [SELECT Id, Body, Revision, CreatedBy.Name, CreatedById,
            
                                        (SELECT EditedAttribute, FeedEntityId, Revision, Value, CreatedBy.Name, CreatedById
                                         FROM FeedRevisions
                                         ORDER BY Revision DESC)
                                         
                                        FROM FeedItem 
                                        WHERE Id=:feedItemId];
                                        
            if (feedItems.size() != 1) {
                feedItemAndRevisionInfo = new FeedItemAndRevisions(null, null);
            }
            else {
                feedItemAndRevisionInfo = new FeedItemAndRevisions(feedItems.get(0), feedItems.get(0).FeedRevisions);
            }
        }
        
        return feedItemAndRevisionInfo;
    }


    
    public List<CommentAndRevisions> getCommentsAndRevisions() {
    
        commentsAndRevisions = null;
        
        if (feedItemId != null) {
    
            commentsAndRevisions = new List<CommentAndRevisions>();
            
            List<FeedComment> comments = [SELECT Id, CommentBody, Revision, CreatedBy.Name, CreatedById,
            
                                          (SELECT EditedAttribute, FeedEntityId, Revision, Value, CreatedBy.Name, CreatedById
                                           FROM FeedRevisions
                                           ORDER BY Revision DESC)
                                           
                                          FROM FeedComment 
                                          WHERE feedItemId=:feedItemId 
                                          ORDER BY CreatedDate];
 
            for (FeedComment c : comments) {
                CommentAndRevisions commentInfo = new CommentAndRevisions(c, c.FeedRevisions);
                commentsAndRevisions.add(commentInfo);
            }

        }
        return commentsAndRevisions;
    }

    // Inner helper class.
    public class FeedItemAndRevisions {

        public FeedItem currentFeedItem { get; set; }
        public List<FeedRevision> revisions { get; set; }

        public FeedItemAndRevisions(FeedItem currentFeedItem, List<FeedRevision> revisions) {
            this.currentFeedItem = currentFeedItem;
            this.revisions = revisions;
        }
        
    }

    // Inner helper class.
    public class CommentAndRevisions {

        public FeedComment comment { get; set; }
        public List<FeedRevision> commentRevisions { get; set; }

        public CommentAndRevisions(FeedComment comment, List<FeedRevision> commentRevisions) {
            this.comment = comment;
            this.commentRevisions = commentRevisions;
        }
        
    }

}
