 # المرحلة الأولى: بناء التطبيق باستخدام gradle المثبت جاهزاً
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# نسخ ملفات الإعداد فقط أولاً لتحسين السرعة
COPY build.gradle settings.gradle ./
# نسخ الكود المصدري
COPY src ./src

# البناء باستخدام أمر gradle المباشر (بدون ./gradlew)
RUN gradle bootJar --no-daemon && rm -f build/libs/*-plain.jar

# المرحلة الثانية: التشغيل
FROM amazoncorretto:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
