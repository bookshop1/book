package admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import main.Book;


@Service
public class AdminService {
	
	@Autowired
	AdminMapper mapper;
	
	public List<AdminBook> findAll() {
		return mapper.findAll();
	}

	public AdminBook findById(int b_id) {
		
		return mapper.findById(b_id);
	}

	public int deleteBook(int b_id) {
		return mapper.delete(b_id);		
	}

	public void insertbook(AdminBook book) {
		mapper.insertbook(book);
	}

	public void updateBook(AdminBook book) {
		mapper.updateBook(book);
		
	}

	/*
	public List<AdminBook> search(String keyword) {
		return mapper.search(keyword);
	}
	
	public List<AdminBook> findByCategory(String category) {
        return mapper.findByCategory(category);
    }
    */
}
