package com.hwadee.fsc.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Knife4jConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Hwadee-FSC API")
                        .version("1.0.0")
                        .description("家校通后端服务接口文档")
                        .contact(new Contact().name("Hwadee").email("admin@hwadee.com")));
    }
}
