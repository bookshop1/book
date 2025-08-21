package login;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import join.UserVO;

@Mapper
public interface LoginMapper {

    //@Select("SELECT u_id, id, password, address, email, num, role FROM users WHERE id = #{id} AND password = #{password}")
    //UserVO getUser(@Param("id") String id, @Param("password") String password);

    
    @Select("SELECT u_id, id, password, address, email, num, role FROM users WHERE id = #{id}")
    UserVO findById(@Param("id") String id);
}