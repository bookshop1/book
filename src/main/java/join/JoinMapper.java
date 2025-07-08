package join;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface JoinMapper {
    int insertUser(UserVO user);
}
