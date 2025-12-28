package com.example.demo;

import com.google.code.kaptcha.impl.DefaultKaptcha;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@CrossOrigin(origins = "*") // مهم جداً للسماح لصفحة الويب بالاتصال
public class CaptchaController {

    private final DefaultKaptcha captchaProducer;
    // مخزن مؤقت لحفظ الرموز (في المشاريع الكبيرة نستخدم Redis)
    private static final Map<String, String> cache = new ConcurrentHashMap<>();

    public CaptchaController(DefaultKaptcha captchaProducer) {
        this.captchaProducer = captchaProducer;
    }

    // 1. إنشاء كابتشا جديدة
    @GetMapping("/captcha/new")
    public Map<String, String> newCaptcha() throws Exception {
        String text = captchaProducer.createText();
        BufferedImage image = captchaProducer.createImage(text);
        String id = UUID.randomUUID().toString();

        cache.put(id, text);

        // حفظ الصورة مؤقتاً في مجلد النظام
        File tempDir = new File(System.getProperty("java.io.tmpdir"));
        ImageIO.write(image, "png", new File(tempDir, id + ".png"));

        Map<String, String> response = new HashMap<>();
        response.put("captchaId", id);
        response.put("imageUrl", "/captcha/image/" + id);
        return response;
    }

    // 2. عرض الصورة للمتصفح
    @GetMapping(value = "/captcha/image/{id}", produces = MediaType.IMAGE_PNG_VALUE)
    public byte[] getImage(@PathVariable String id) throws Exception {
        File tempFile = new File(System.getProperty("java.io.tmpdir"), id + ".png");
        return Files.readAllBytes(tempFile.toPath());
    }

    // 3. التحقق من إجابة المستخدم
    @PostMapping("/captcha/verify")
    public Map<String, Boolean> verify(@RequestBody Map<String, String> data) {
        String id = data.get("id");
        String answer = data.get("answer");

        boolean ok = cache.containsKey(id) && cache.get(id).equalsIgnoreCase(answer);
        if (ok) cache.remove(id); // حذفها بعد النجاح لمنع إعادة الاستخدام

        Map<String, Boolean> response = new HashMap<>();
        response.put("success", ok);
        return response;
    }
}
