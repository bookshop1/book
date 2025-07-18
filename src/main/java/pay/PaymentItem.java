package pay;

import lombok.ToString;

import lombok.Data;

@Data
@ToString
public class PaymentItem {
	private int itemId;
    private String title;
    private int quantity;
    private int price;
}
