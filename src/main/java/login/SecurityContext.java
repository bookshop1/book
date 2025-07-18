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
	            .antMatchers("/login/**", "/join/**", "/resources/**").permitAll() // 로그인 폼, 회원가입, 정적리소스 허용
	            .anyRequest().authenticated()
	        .and()
	        .formLogin()
	            .loginPage("/login/loginform")           // 로그인 폼 GET 요청 URL
	            .loginProcessingUrl("/login")            // 로그인 처리 POST 요청 URL (JSP form action과 맞춤)
	            .successHandler(successHandler)
	            .failureUrl("/login/loginform?error=true")  // 로그인 실패 시 다시 로그인 폼으로 (에러 쿼리 추가)
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
