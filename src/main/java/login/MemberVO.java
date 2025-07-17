package login;

import lombok.Data;

@Data
public class MemberVO {
	private String id;
	private String password;
	private String role;
}
