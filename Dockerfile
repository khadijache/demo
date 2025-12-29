FROM gradle:8.5-jdk17 AS build
WORKDIR /app
COPY . .
# سنقوم ببناء الملف ثم حذف أي ملف ينتهي بـ plain ليبقى الملف الصحيح فقط
RUN ./gradlew bootJar --no-daemon && rm build/libs/*-plain.jar

FROM openjdk:17-jdk-slim
WORKDIR /app
# الآن سيجد Docker ملفاً واحداً فقط وينسخه بكل سهولة
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]