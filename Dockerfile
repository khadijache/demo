# المرحلة الأولى: بناء التطبيق
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# نسخ الملفات اللازمة للبناء
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

# إعطاء صلاحية التنفيذ وبناء التطبيق
RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon

# المرحلة الثانية: التشغيل (استخدام Eclipse Temurin بدلاً من OpenJDK المحذوف)
FROM eclipse-temurin:17-jre-slim
WORKDIR /app

# نسخ ملف الـ jar الناتج من مرحلة البناء
COPY --from=build /app/build/libs/*.jar app.jar

# إعدادات التشغيل النهائية مع وضع headless
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]