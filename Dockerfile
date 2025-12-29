# المرحلة الأولى: بناء التطبيق
FROM gradle:8.5-jdk17 AS build
WORKDIR /app
COPY . .
RUN ./gradlew bootJar --no-daemon && rm -f build/libs/*-plain.jar

# المرحلة الثانية: التشغيل (استبدلنا المصدر هنا)
FROM amazoncorretto:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]