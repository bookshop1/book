package bag;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface BagMapper {
	@Select("SELECT ba.b_id, b.title, b.pic, ba.quantity, b.price FROM bag ba JOIN book b ON ba.b_id = b.b_id WHERE ba.u_id = #{u_id}")
    List<BagBook> findBagItemsByUserId(@Param("u_id")int u_id);

	@Select("SELECT NVL(SUM(ba.quantity * b.price), 0) "
			+ "FROM bag ba "
			+ "JOIN book b ON ba.b_id = b.b_id "
			+ "WHERE ba.u_id = #{u_id}")
    int totalPrice(@Param("u_id")int u_id);

	@Delete("DELETE FROM bag "
			+ "WHERE u_id = #{u_id} "
			+ "AND b_id = #{b_id}")
    void deleteFromBag(@Param("u_id") int userId, @Param("b_id") int b_id);
}