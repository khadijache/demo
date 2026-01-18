# المرحلة الأولى: بناء التطبيق باستخدام النسخة المطلوبة بدقة (8.14)
FROM gradle:8.14-jdk17 AS build
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

# إعدادات التشغيل بوضع headless
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]