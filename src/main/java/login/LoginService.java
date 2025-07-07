package login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("loginService") //setting.xml에 bean설정 필요없는 대신 (context-scan) 해줘야함
public class LoginService {
	@Autowired
	LoginMapper mapper;
	public int login(String id, String password) {
        // 실제 구현은 DB에서 조회 후 일치 여부 판단
        // 예) loginMapper.findByIdAndPassword(id, password) != null
        return mapper.login(id, password);
    }
}
