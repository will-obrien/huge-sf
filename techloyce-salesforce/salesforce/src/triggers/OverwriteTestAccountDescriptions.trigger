trigger OverwriteTestAccountDescriptions on Account (before insert) {
for(Account a: Trigger.new){

    if (a.Name.toLowerCase().contains('test')){

      a.Description =

        'This Account is probably left over from testing. It should probably be deleted.';

    }
}
}