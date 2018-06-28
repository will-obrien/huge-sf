@IsTest
public class UserLookupTest {
    @IsTest
    public static void testUserLookup() {
        Id testId = UserLookup.getId('ciron');
        System.assertEquals('005i000000264p4AAA', testId);
    }
}