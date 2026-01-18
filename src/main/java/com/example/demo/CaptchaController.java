package com.example.demo;

import com.google.code.kaptcha.impl.DefaultKaptcha;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@CrossOrigin(origins = "*")
@RestController
public class CaptchaController {

    private final DefaultKaptcha captchaProducer;
    // مخزن في الذاكرة لحفظ الرموز والتحقق منها
    private static final Map<String, String> cache = new ConcurrentHashMap<>();

    public CaptchaController(DefaultKaptcha captchaProducer) {
        this.captchaProducer = captchaProducer;
    }

    // 1. إنشاء كابتشا جديدة (توليد الرموز فقط)
    @GetMapping("/captcha/new")
    public Map<String, String> newCaptcha() {
        String text = captchaProducer.createText();
        String id = UUID.randomUUID().toString();

        // حفظ النص المرتبط بالمعرف في الذاكرة
        cache.put(id, text);

        Map<String, String> response = new HashMap<>();
        response.put("captchaId", id);
        response.put("imageUrl", "/captcha/image/" + id);
        return response;
    }

    // 2. تحويل الرموز إلى صورة وبثها مباشرة (بدون حفظ ملفات)
    @GetMapping(value = "/captcha/image/{id}", produces = MediaType.IMAGE_PNG_VALUE)
    public byte[] getImage(@PathVariable String id) throws Exception {
        String text = cache.get(id);
        if (text == null) {
            throw new RuntimeException("الرمز منتهي الصلاحية أو غير موجود");
        }

        // رسم الحروف والرموز في صورة داخل الذاكرة
        BufferedImage image = captchaProducer.createImage(text);

        // تحويل الصورة إلى مصفوفة بايتات للبث عبر الإنترنت
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "png", baos);

        return baos.toByteArray();
    }

    // 3. التحقق من إجابة المستخدم
    @PostMapping("/captcha/verify")
    public Map<String, Boolean> verify(@RequestBody Map<String, String> data) {
        String id = data.get("id");
        String answer = data.get("answer");

        boolean ok = cache.containsKey(id) && cache.get(id).equalsIgnoreCase(answer);
        if (ok) cache.remove(id); // حذف الرمز بعد النجاح للأمان

        Map<String, Boolean> response = new HashMap<>();
        response.put("success", ok);
        return response;
    }
}