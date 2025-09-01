package admin;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;


@Mapper
public interface AdminMapper {

	@Select("select * from book")
	public List<AdminBook> findAll();
	
	@Select("select * from book where b_id = #{b_id}")
	public AdminBook findById(int b_id);

	@Insert("INSERT INTO book (b_id, num, pic, title, author, price, info) VALUES (book_id_seq.NEXTVAL, #{num}, #{pic}, #{title}, #{author}, #{price}, #{info})")
	public int insertbook(AdminBook book);

	@Delete("DELETE FROM book WHERE b_id = #{b_id}")
	public int delete(int b_id);

	@Update("UPDATE book SET " +
            "num = #{num}, " +
            "pic = #{pic}, " +
            "title = #{title}, " +
            "author = #{author}, " +
            "price = #{price}, " +
            "info = #{info} " +
            "WHERE b_id = #{b_id}")
	public void updateBook(AdminBook book);

}
