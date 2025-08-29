package view;

import java.time.LocalDateTime;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class Comment {
	private int id;
	private int b_id;
	private String writer;
	private String content;
	private LocalDateTime regDate;
	  private int score;

}
