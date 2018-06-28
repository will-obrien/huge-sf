/**
 *
 */
public class SalaryHistoryRecord  implements Comparable {

    private Decimal value;
    private Date valueDate;

    public SalaryHistoryRecord(Decimal val, Date valDate) {
        this.value = val;
        this.valueDate = valDate;
    }

    public Decimal getValue() {
        return this.value;
    }

    public Date getValueDate() {
        return this.valueDate;
    }

    public void setValueDate(Date dVal) {
        this.valueDate = dVal;
    }

    public Integer compareTo(Object objToCompare) {
        Date dateToCompare = ((SalaryHistoryRecord) objToCompare).getValueDate();
        if (this.getValueDate() > dateToCompare) {
            return 1;
        } else if (this.getValueDate() < dateToCompare) {
            return -1;
        }
        return 0;
    }
}