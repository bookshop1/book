package main;

import java.util.List;

import org.apache.ibatis.annotations.Select;

public interface MainMapper {
	@Select("select * from book")
	public List<Book> findAll();

	@Select("select * from book where num = #{num}")
	public Book findBookById(int num);
	
	@Select("select * from book where title like '%' || #{keyword} || '%' "
			+ "or author like '%' || #{keyword} || '%'")
	public List<Book> search(String keyword);
}
