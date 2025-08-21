package login;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import join.UserVO; // 실제 UserVO 패키지 경로

@Service
public class CustomUserDetailsService implements UserDetailsService {
	
	@Autowired
	LoginMapper mapper;
	
	@Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException { // 파라미터 이름을 id로 명확하게 변경
        // Mapper의 새로운 메소드 호출
        UserVO member = mapper.findById(id); 
        
        if (member == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + id);
        }

        // UserVO 대신 MemberVO를 사용하셨던 것 같아 변수명을 member로 유지했습니다.
        // vo.MemberVO 대신 join.UserVO를 사용하시는 것으로 보입니다. 타입은 맞게 조정해주세요.
        return new User(
            member.getId(), // Spring Security의 username으로 사용할 필드
            member.getPassword(), // DB에 저장된 암호화된 비밀번호
            Collections.singleton(new SimpleGrantedAuthority(member.getRole())) // 권한
        );
    }
}