# المرحلة الأولى: بناء التطبيق
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# نسخ كل الملفات الموجودة في المستودع إلى الحاوية
COPY . .

# إعطاء صلاحية التشغيل للملف (تأكد أن الاسم gradlew وليس Gradlew)
RUN chmod +x gradlew

# بناء التطبيق باستخدام الـ wrapper
RUN ./gradlew bootJar --no-daemon -x test

# المرحلة الثانية: التشغيل
FROM amazoncorretto:17-alpine
WORKDIR /app

# نسخ ملف الـ jar الناتج من مجلد build/libs
COPY --from=build /app/build/libs/*.jar app.jar

# إعدادات التشغيل بوضع headless
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]