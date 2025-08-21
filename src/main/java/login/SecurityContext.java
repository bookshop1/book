package login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityContext {

    private final CustomerLoginSuccessHandler successHandler;
    private final CustomerLoginDeniedHandler deniedHandler;
    private final CustomUserDetailsService customUserDetailsService;
    
    @Autowired
    public void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(customUserDetailsService).passwordEncoder(passwordEncoder());
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                // 관리자(ADMIN)만 접근 가능한 URL
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers("/chart/**").hasRole("ADMIN")
                
                // 로그인한 사용자만 접근 가능한 URL
                .antMatchers("/paymentHistory/**").authenticated()
                .antMatchers("/pay/**").permitAll()
                
                // 누구나 접근 가능한 URL (정적 리소스 추가)
                .antMatchers("/", "/main/**").permitAll()
                .antMatchers("/login/**").permitAll()
                .antMatchers("/join/**").permitAll()
                .antMatchers("/view/**").permitAll()
                .antMatchers("/bag/**").permitAll()
                .antMatchers("/images/**", "/css/**", "/js/**").permitAll()
                
                // 위에서 설정한 URL 외의 모든 요청은 인증(로그인) 필요
                .anyRequest().authenticated()
            )
            // 폼 로그인 설정
            .formLogin(form -> form
                .loginPage("/login/loginform")
                .loginProcessingUrl("/login")
                .successHandler(successHandler)
                .failureUrl("/login/loginform?error=true")
                .usernameParameter("username")
                .passwordParameter("password")
            )
            // 로그아웃 설정
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
            )
            // 예외 처리 설정
            .exceptionHandling(ex -> ex
                .accessDeniedHandler(deniedHandler)
            );
            
        // http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}