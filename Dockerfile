# المرحلة الأولى: بناء التطبيق باستخدام محرك Gradle المثبت في الصورة
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# نسخ ملفات المشروع (سيتم نسخ build.gradle و src وغيرها)
COPY . .

# استخدام أمر gradle المباشر (هذا الأمر لا يحتاج لمجلد gradle/wrapper)
RUN gradle bootJar --no-daemon -x test

# المرحلة الثانية: التشغيل
FROM amazoncorretto:17-alpine
WORKDIR /app

# نسخ ملف الـ jar الناتج من المسار الافتراضي لـ Gradle
COPY --from=build /app/build/libs/*.jar app.jar

# إعدادات التشغيل بوضع headless
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]