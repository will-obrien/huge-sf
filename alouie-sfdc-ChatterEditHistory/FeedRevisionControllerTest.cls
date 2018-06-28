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
 * Tests for the controller of the VisualForce page that displays the editing history for a Chatter thread.

 * 
 * @author arthur.louie
 */

@IsTest
public class FeedRevisionControllerTest {

    public static testMethod void testInvalidFeedItem() {
        FeedRevisionController controller = new FeedRevisionController();
        controller.feedItemId = 'My invalid feed item ID';  // Not realistic usage -- normally the feedItemId gets parsed out of the URL.
        FeedRevisionController.FeedItemAndRevisions feedItemAndRevs = controller.getFeedItemAndRevisions();
        System.assertEquals(null, feedItemAndRevs.currentFeedItem, 'currentFeedItem should have been null.');
    }

    public static testMethod void testNoFeedItemInUrl() {
        FeedRevisionController controller = new FeedRevisionController();
        controller.url = 'http://lycos.com';
        FeedRevisionController.FeedItemAndRevisions feedItemAndRevs = controller.getFeedItemAndRevisions();
        System.assertEquals(null, feedItemAndRevs, 'feedItemAndRevs should have been null.');
    }

    @IsTest(SeeAllData=true)
    public static void testEditedFeedItem() {
        // Post a feed item.
        String originalFeedItemText = 'Original feed item text.';
        ConnectApi.FeedElement f = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), 'me', ConnectApi.FeedElementType.FeedItem, originalFeedItemText);
        
        // Edit it.
        ConnectApi.TextSegmentInput textInput = new ConnectApi.TextSegmentInput();
        textInput.text = 'Edited post';

        ConnectApi.MessageBodyInput bodyInput = new ConnectApi.MessageBodyInput();
        bodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        bodyInput.messageSegments.add(textInput);

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = bodyInput;
        
        ConnectApi.ChatterFeeds.updateFeedElement(Network.getNetworkId(), f.id, input);
        
        // Test the controller.
        FeedRevisionController controller = new FeedRevisionController();
        controller.url = 'https://mycustomdomain.salesforce.com/' + f.id;
        FeedRevisionController.FeedItemAndRevisions feedItemAndRevs = controller.getFeedItemAndRevisions();
        
        System.assertEquals(f.id, feedItemAndRevs.currentFeedItem.id, 'Unexpected feed item ID.');
        System.assertEquals(1, feedItemAndRevs.revisions.size(), 'Unexpected number of revisions.');
        System.assertEquals(originalFeedItemText, feedItemAndRevs.revisions.get(0).value, 'Unexpected old value for first revision.');
    }

    @IsTest(SeeAllData=true)
    public static void testEditedComment() {
        // Post a feed item.
        ConnectApi.FeedElement f = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), 'me', ConnectApi.FeedElementType.FeedItem, 'My feed item');

        // Post a comment.
        String originalCommentText = 'Original feed item text.';
        ConnectApi.Comment c = ConnectApi.ChatterFeeds.postCommentToFeedElement(Network.getNetworkId(), f.id, originalCommentText);
        
        // Edit the comment.
        ConnectApi.TextSegmentInput textInput = new ConnectApi.TextSegmentInput();
        textInput.text = 'Edited comment';

        ConnectApi.MessageBodyInput bodyInput = new ConnectApi.MessageBodyInput();
        bodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        bodyInput.messageSegments.add(textInput);

        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        input.body = bodyInput;
        
        ConnectApi.ChatterFeeds.updateComment(Network.getNetworkId(), c.id, input);
        
        // Test the controller.
        FeedRevisionController controller = new FeedRevisionController();
        controller.url = 'https://mycustomdomain.salesforce.com/' + f.id;
        List<FeedRevisionController.CommentAndRevisions> commentsAndRevs = controller.getCommentsAndRevisions();
        
        System.assertEquals(1, commentsAndRevs.size(), 'Unexpected number of CommentAndRevisions.');
        System.assertEquals(c.id, commentsAndRevs.get(0).comment.id, 'Unexpected comment ID.');
        System.assertEquals(1, commentsAndRevs.get(0).commentRevisions.size(), 'Unexpected number of revisions.');
        System.assertEquals(originalCommentText, commentsAndRevs.get(0).commentRevisions.get(0).value, 'Unexpected old value for first revision.');
    }
    
}
