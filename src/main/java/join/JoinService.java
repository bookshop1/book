package join;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class JoinService {

    @Autowired
     JoinMapper joinMapper;

    public int register(UserVO user) {
        return joinMapper.insertUser(user);
    }
}
