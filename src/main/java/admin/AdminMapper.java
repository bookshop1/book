package admin;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import main.Book;


@Mapper
public interface AdminMapper {

	@Select("select * from book")
	public List<AdminBook> findAll();
	
	@Select("select * from book where b_id = #{b_id}")
	public AdminBook findById(int b_id);

	@Insert("INSERT INTO book (b_id, num, pic, title, author, price, info, category) VALUES (book_id_seq.NEXTVAL, 0, #{pic}, #{title}, #{author}, #{price}, #{info}, #{category})")
	public int insertbook(AdminBook book);

	@Delete("DELETE FROM book WHERE b_id = #{b_id}")
	public int delete(int b_id);

	@Update("UPDATE book SET " +
            "num = #{num}, " +
            "pic = 0, " +
            "title = #{title}, " +
            "author = #{author}, " +
            "price = #{price}, " +
            "info = #{info}, " +
            "category = #{category} " +
            "WHERE b_id = #{b_id}")
	public void updateBook(AdminBook book);
	
	@Select("select * from book where title like '%' || #{keyword} || '%' "
			+ "or author like '%' || #{keyword} || '%'")
	public List<AdminBook> search(String keyword);
	
	@Select("SELECT * FROM book WHERE category = #{category}")
    List<AdminBook> findByCategory(@Param("category") String category);
}
