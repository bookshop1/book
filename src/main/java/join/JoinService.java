package join;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // final 필드에 대한 생성자를 자동으로 만들어줍니다.
public class JoinService {

    private final JoinMapper mapper; // DB와 통신하는 레포지토리
    private final PasswordEncoder passwordEncoder; // SecurityConfig에 Bean으로 등록한 그것!
    
    public UserVO findUserById(int userId) {
        return mapper.findUserById(userId);
    }

    public int register(UserVO userVO) {
        
        // 1. 사용자가 입력한 평문 비밀번호를 가져옵니다.
        String rawPassword = userVO.getPassword();

        // 2. PasswordEncoder를 사용해 비밀번호를 암호화합니다.
        String encodedPassword = passwordEncoder.encode(rawPassword);

        // 3. 암호화된 비밀번호를 UserVO 객체에 다시 설정합니다.
        userVO.setPassword(encodedPassword);

        // 4. 암호화된 비밀번호가 담긴 UserVO를 DB에 저장합니다.
        return mapper.insertUser(userVO);
    }
}