/**
 * Helper class it allow to test and mock history.
 */
public class SalaryHistoryWrapper {

    public SalaryHistoryWrapper(Object oValue, Object nValue, DateTime dt) {
        this.OldValue = oValue;
        this.NewValue = nValue;
        this.CreatedDate = dt;
    }

    public Object OldValue;
    public Object NewValue;
    public DateTime CreatedDate;
}