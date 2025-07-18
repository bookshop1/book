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
		
		// ���� �� LoginService���� authorities�� ����� ���� Ȯ���� �Ŀ�
		// ���ѿ� �ش��ϴ� �������� �̵�
		// authentication.getAuthorities() �Լ���
		// LoginService���� authorities�� ����� ���� Ȯ���� �� ����
		System.out.println("���� �� : " + authentication.getAuthorities());
		
		// �Ʒ� �ڵ� �����ϴ� ���� : authorities.getAuthority()�� ���ڿ��� �ƴϹǷ� ���ڿ��� ��ȯ
		List<String> roleNames = new ArrayList<String>();
		authentication.getAuthorities().forEach(authorities->{
			roleNames.add(authorities.getAuthority());
		});
		
		// ��ȯ�� ���ڿ��� Ȯ���ϰ� ������ �̵�
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/admin/main");	// PageController���� ��� ó��
		} else if(roleNames.contains("ROLE_USER")) {
			response.sendRedirect("/main");
		} else {
			response.sendRedirect("/login/accessError");
		}
	}

}