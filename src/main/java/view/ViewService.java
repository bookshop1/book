package view;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ViewService {
    
    @Autowired
    ViewMapper mapper;

    public View getDetail(int id) {
        return mapper.findById(id);
    }
}
