# استخدام نسخة 17 المستقرة
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
# تأكد من عمل ./gradlew build قبل بناء الصورة
# استبدلي السطر القديم بهذا السطر:
# هذا السطر يخبر Docker بأن يتجاهل ملف plain ويأخذ ملف التطبيق الأساسي فقط
COPY build/libs/*-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]