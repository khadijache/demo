# المرحلة الأولى: بناء التطبيق
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# نسخ كل محتويات مجلد demo إلى بيئة البناء
# إذا كان الـ Dockerfile خارج مجلد demo، نستخدم:
COPY demo/ .

# إذا كان الـ Dockerfile داخل مجلد demo، نستخدم:
# COPY . .

# إعطاء صلاحية وبناء التطبيق
RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon -x test

# المرحلة الثانية: التشغيل
FROM amazoncorretto:17-alpine
WORKDIR /app

# نسخ ملف الـ jar الناتج (لاحظ المسار)
COPY --from=build /app/build/libs/*.jar app.jar

# إعدادات التشغيل
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]