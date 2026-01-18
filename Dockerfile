# 1. مرحلة البناء (تأكد من وجود هذه الأسطر)
FROM gradle:8.5-jdk17 AS build
WORKDIR /app
COPY . .
RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon

# 2. مرحلة التشغيل (هنا التعديل الذي قمت به)
FROM openjdk:17-jdk-slim
WORKDIR /app
# السطر التالي هو الأهم، بدونه لن يجد Docker ملف الـ jar
COPY --from=build /app/build/libs/*.jar app.jar

# السطر الذي قمت بتعديله أنت (وضعه صحيح هنا)
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]