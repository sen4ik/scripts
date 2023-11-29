package com.cb.auth.config.security;

import lombok.extern.log4j.Log4j2;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/* I needed a way to point our React app to the backend when running it locally. The issue was that the browsers CORS
did not allow it to work and all the requests to the backend were blocked. The only way that I found so far is to
use the below config.
You will also need to tweak the SecurityConfig and replace .cors().disable() with .cors().and() to enable CORS.
*/
@Configuration
@Log4j2
public class CorsConfig implements WebMvcConfigurer {

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		log.info("Added CORS mappings");
		registry.addMapping("/**")
				.allowedOrigins("http://localhost:3000")
				.allowedMethods("GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS")
				.allowedHeaders("*")
				.allowCredentials(true)
				.maxAge(3600);
	}

}