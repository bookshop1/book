package join;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface JoinMapper {
	
    int insertUser(UserVO user);
    
    @Select("SELECT * FROM users WHERE u_id = #{userId}")
    UserVO findUserById(@Param("userId") int userId);
    
}

