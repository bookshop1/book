package main;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("mainService")
public class MainService {

	@Autowired
	MainMapper mapper;
	
	public List<Book> findAll() {
		return mapper.findAll();
	}
	
}
