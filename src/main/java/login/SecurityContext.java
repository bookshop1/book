package login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityContext {
	
	@Autowired
	private CustomerLoginSuccessHandler successHandler;

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
	    http
	        .authorizeRequests()
	            .antMatchers("/admin/**").hasAuthority("ROLE_ADMIN")
	            .antMatchers("/user/**").hasAuthority("ROLE_USER")
	            .antMatchers("/main/**").permitAll()
	            .antMatchers("/login/**", "/join/**", "/resources/**").permitAll() // �α��� ��, ȸ������, �������ҽ� ���
	            .anyRequest().authenticated()
	        .and()
	        .formLogin()
	            .loginPage("/login/loginform")           // �α��� �� GET ��û URL
	            .loginProcessingUrl("/login")            // �α��� ó�� POST ��û URL (JSP form action�� ����)
	            .successHandler(successHandler)
	            .failureUrl("/login/loginform?error=true")  // �α��� ���� �� �ٽ� �α��� ������ (���� ���� �߰�)
	            .usernameParameter("username")
	            .passwordParameter("password")
	            .permitAll()
	        .and()
	        .logout()
	            .logoutUrl("/logout")
	            .logoutSuccessUrl("/login/loginform?logout=true")
	            .permitAll()
	        .and()
	        .exceptionHandling()
	            .accessDeniedHandler(new CustomerLoginDeniedHandler());

	    return http.build();
	}
}
