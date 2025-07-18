package pay;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Pay {
	private int b_id;
	private int num;
	private String pic;
	private String title;
	private String author;
	private int price;
	private String info;
	
}
