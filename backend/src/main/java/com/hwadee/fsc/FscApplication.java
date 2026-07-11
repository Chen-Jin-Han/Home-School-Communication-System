package com.hwadee.fsc;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.hwadee.fsc.mapper")
public class FscApplication {
    public static void main(String[] args) {
        SpringApplication.run(FscApplication.class, args);
    }
}
