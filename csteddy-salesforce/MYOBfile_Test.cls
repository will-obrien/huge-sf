@istest
public class MYOBfile_Test {

static testMethod void MYOBfile_JSON() {

MYOBfile f = new MYOBfile();
system.debug(f.Id);
system.debug(f.Name);
system.debug(f.LibraryPath);
system.debug(f.ProductVersion);
system.debug(f.Uri);
system.debug(f.Country);

        }
}
