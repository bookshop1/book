package login;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomerLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
		// 성공 시 LoginService에서 authorities에 저장된 값을 확인한 후에
		// 권한에 해당하는 페이지로 이동
		// authentication.getAuthorities() 함수로
		// LoginService에서 authorities에 저장된 값을 확인할 수 있음
		System.out.println("성공 시 : " + authentication.getAuthorities());
		
		// 아래 코드 실행하는 이유 : authorities.getAuthority()가 문자열이 아니므로 문자열로 반환
		List<String> roleNames = new ArrayList<String>();
		authentication.getAuthorities().forEach(authorities->{
			roleNames.add(authorities.getAuthority());
		});
		
		// 변환한 문자열을 확인하고 페이지 이동
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/admin/main");	// PageController에서 모두 처리
		} else if(roleNames.contains("ROLE_USER")) {
			response.sendRedirect("/main");
		} else {
			response.sendRedirect("/login/accessError");
		}
	}

}