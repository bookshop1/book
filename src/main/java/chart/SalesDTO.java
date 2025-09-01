package chart;

public class SalesDTO {
    private String label;    // 날짜(YY/MM/DD, YYYY-MM 등)
    private int totalAmount; // 총 매출액

    // getter/setter
    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public int getTotalAmount() { return totalAmount; }
    public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }
}

