package login;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface LoginMapper {
	@Select("SELECT COUNT(*) FROM users WHERE id = #{id} AND password = #{password}")
	public int login(@Param("id") String id,@Param("password") String password);
	
	
	@Select("SELECT id, password, role FROM users WHERE id = #{id}")
	MemberVO findById(@Param("id") String id);
	
}
