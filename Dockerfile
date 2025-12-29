 # المرحلة الأولى: بناء التطبيق (Build)
 FROM gradle:8.5-jdk17 AS build
 WORKDIR /app
 COPY . .
 RUN ./gradlew bootJar --no-daemon

 # المرحلة الثانية: تشغيل التطبيق (Run)
 FROM openjdk:17-jdk-slim
 WORKDIR /app
 COPY --from=build /app/build/libs/*[!plain].jar app.jar
 EXPOSE 8080
 ENTRYPOINT ["java", "-jar", "app.jar"]