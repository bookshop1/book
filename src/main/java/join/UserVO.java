package join;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class UserVO {
	 private int u_id;
	    private String id;
	    private String password;
	    private String address;
	    private String email;
	    private int num;
	    private String role;
}
