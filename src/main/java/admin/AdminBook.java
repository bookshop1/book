package admin;

import javax.persistence.Entity;
import javax.persistence.Table;

import lombok.Data;
import lombok.ToString;

@Entity
@Table(name = "book")
@Data
@ToString
public class AdminBook {
	
	private int b_id;
	private int num;
	private String pic;
	private String title;
	private String author;
	private int price;
	private String info;
	private String category;
}
