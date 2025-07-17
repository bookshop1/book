package login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import join.UserVO;

@Service
public class LoginService {

    @Autowired
    private LoginMapper mapper;

    public UserVO getUser(String id, String password) {
        return mapper.getUser(id, password);
    }
}