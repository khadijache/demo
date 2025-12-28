# استخدام نسخة 17 المستقرة
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
# تأكد من عمل ./gradlew build قبل بناء الصورة
COPY build/libs/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]