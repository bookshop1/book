package view;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface ViewMapper {
	
	@Select("select * from book where b_id = #{id}")
	public View findById(int id);
	
}
