package admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class AdminService {
	
	@Autowired
	AdminMapper mapper;
	
	public List<Book> findAll() {
		return mapper.findAll();
	}

	public Book findById(int b_id) {
		
		return mapper.findById(b_id);
	}

	public int deleteBook(int b_id) {
		return mapper.delete(b_id);		
	}

	public void insertbook(Book book) {
		mapper.insertbook(book);
	}

	public void updateBook(Book book) {
		mapper.updateBook(book);
		
	}

}
