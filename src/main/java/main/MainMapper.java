package main;

import java.util.List;

import org.apache.ibatis.annotations.Select;

public interface MainMapper {
	@Select("select * from book")
	public List<Book> findAll();
}
