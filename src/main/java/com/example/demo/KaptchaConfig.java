
package com.example.demo;

import com.google.code.kaptcha.impl.DefaultKaptcha;
import com.google.code.kaptcha.util.Config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Properties;

@Configuration
public class KaptchaConfig {

    @Bean
    public DefaultKaptcha captchaProducer() {
        DefaultKaptcha kaptcha = new DefaultKaptcha();
        Properties properties = new Properties();

        // إعدادات المظهر
        properties.put("kaptcha.border", "no");
        properties.put("kaptcha.textproducer.char.length", "5");
        properties.put("kaptcha.textproducer.font.color", "black");
        properties.put("kaptcha.image.width", "200");
        properties.put("kaptcha.image.height", "50");

        kaptcha.setConfig(new Config(properties));
        return kaptcha;
    }
}