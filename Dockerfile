# المرحلة الأولى: بناء التطبيق
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# نسخ الملفات الأساسية
COPY . .

# بناء التطبيق مع تجاهل الاختبارات
RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon -x test

# المرحلة الثانية: التشغيل باستخدام Amazon Corretto (الأكثر توافراً)
FROM amazoncorretto:17-alpine
WORKDIR /app

# نسخ ملف الـ jar الناتج
COPY --from=build /app/build/libs/*.jar app.jar

# إعدادات التشغيل بوضع headless
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]