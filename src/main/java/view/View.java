package view;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class View {
	private int b_id;
	private int num;
	private String pic;
	private String title;
	private String author;
	private int price;
	private String info;
	
}
