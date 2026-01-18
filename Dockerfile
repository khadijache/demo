# المرحلة الأولى: بناء التطبيق باستخدام نسخة Gradle متوافقة (8.10)
FROM gradle:8.10-jdk17 AS build
WORKDIR /app

# نسخ ملفات المشروع
COPY . .

# البناء باستخدام أمر gradle المباشر
RUN gradle bootJar --no-daemon -x test

# المرحلة الثانية: التشغيل
FROM amazoncorretto:17-alpine
WORKDIR /app

# نسخ ملف الـ jar الناتج
COPY --from=build /app/build/libs/*.jar app.jar

# إعدادات التشغيل بوضع headless لحل مشكلة السيرفر الأصلية
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]