public class TakeActionBackEndDonationLevels 
{
    public String DonationAsksField {get; set;}
 
    public List<String> getDonationLevels()
    {
      return DonationAsksField.split(',');
    }
}