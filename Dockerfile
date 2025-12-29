# المرحلة الأولى: بناء التطبيق باستخدام نسخة Gradle حديثة (9.0)
FROM gradle:9.0-jdk17 AS build
WORKDIR /app

# نسخ ملفات الإعداد
COPY build.gradle settings.gradle ./
# نسخ الكود المصدري
COPY src ./src

# البناء
RUN gradle bootJar --no-daemon && rm -f build/libs/*-plain.jar

# المرحلة الثانية: التشغيل
FROM amazoncorretto:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
