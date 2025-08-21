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
    
    // 로그인 사용자 장바구니 조회
    @Select("SELECT ba.b_id, b.title, b.pic, ba.quantity, b.price FROM bag ba JOIN book b ON ba.b_id = b.b_id WHERE ba.u_id = #{u_id}")
    List<BagBook> findBagItemsByUserId(@Param("u_id") int u_id);

    // 장바구니 총 가격 계산
    @Select("SELECT NVL(SUM(ba.quantity * b.price), 0) FROM bag ba JOIN book b ON ba.b_id = b.b_id WHERE ba.u_id = #{u_id}")
    int totalPrice(@Param("u_id") int u_id);

    // 장바구니에서 특정 항목 삭제
    @Delete("DELETE FROM bag WHERE u_id = #{u_id} AND b_id = #{b_id}")
    void deleteFromBag(@Param("u_id") int u_id, @Param("b_id") int b_id);

    // 해당 책이 장바구니에 있는지 확인
    @Select("SELECT COUNT(*) FROM bag WHERE u_id = #{u_id} AND b_id = #{b_id} ")
    Integer countItem(@Param("u_id") int u_id, @Param("b_id") int b_id);

    // 해당 책의 현재 수량 조회
    @Select("SELECT quantity FROM bag WHERE u_id = #{u_id} AND b_id = #{b_id} ")
    Integer getQuantity(@Param("u_id") int u_id, @Param("b_id") int b_id);

    // 장바구니 새 항목 추가
    @Insert("INSERT INTO bag (u_id, b_id, quantity) VALUES (#{u_id}, #{b_id}, #{quantity}) ")
    void insertBag(@Param("u_id") int u_id, @Param("b_id") int b_id, @Param("quantity") int quantity);

    // 장바구니 수량 수정 (덮어쓰기)
    @Update("UPDATE bag SET quantity = #{quantity} WHERE u_id = #{u_id} AND b_id = #{b_id}")
    void updateQty(@Param("u_id") int u_id, @Param("b_id") int b_id, @Param("quantity") int quantity);

    // 책 ID로 책 정보 조회 (비로그인 장바구니용)
    @Select("SELECT b_id, title, pic, price, 0 AS quantity FROM book WHERE b_id = #{b_id}")
    BagBook findBookById(@Param("b_id") int b_id);
}