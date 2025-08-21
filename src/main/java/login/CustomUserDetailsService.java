package login;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import join.UserVO; // UserVO import
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final LoginMapper loginMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // LoginMapper를 통해 id로 UserVO 객체를 조회합니다.
        UserVO user = loginMapper.findById(username);
        
        if (user == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }
        
        // UserVO 객체의 정보로 Spring Security의 UserDetails 객체를 생성하여 반환합니다.
        // UserVO 클래스에 getPassword(), getRole() 등의 메소드가 있다고 가정합니다.
        return User.builder()
                .username(user.getId())
                .password(user.getPassword())
                .roles(user.getRole().replace("ROLE_", "")) // "ROLE_USER" -> "USER"
                .build();
    }
}