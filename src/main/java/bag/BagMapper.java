package bag;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
	
	@Select("SELECT COUNT(*) FROM bag WHERE u_id = #{u_id} AND b_id = #{b_id}")
    Integer countItem(@Param("u_id") int u_id, @Param("b_id") int b_id);

    // 장바구니에 새 항목 추가
    @Insert("INSERT INTO bag (u_id, b_id, quantity) VALUES (#{u_id}, #{b_id}, #{quantity})")
    void insertBag(@Param("u_id") int u_id, @Param("b_id") int b_id, @Param("quantity") int quantity);

    // 장바구니 수량 업데이트 (기존 수량에 추가)
    @Update("UPDATE bag SET quantity = quantity + #{quantity} WHERE u_id = #{u_id} AND b_id = #{b_id}")
    void updateQty(@Param("u_id") int u_id, @Param("b_id") int b_id, @Param("quantity") int quantity);
}