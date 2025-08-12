package pay;

import java.util.List;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class Payment {
	private int paymentId;
	private int userId;
	private String name;
	private String num;
	private String address;
	private String post;
	private String detailAddress;
	private String title;
	private int quantity;
	private int price;
	private List<PaymentItem> items;
}
