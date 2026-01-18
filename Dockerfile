# المرحلة الأولى: البناء
FROM gradle:8.5-jdk17 AS build
WORKDIR /app
COPY . .
# السطر الجديد المهم جداً لحل مشكلة Permission denied
RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon && rm -f build/libs/*-plain.jar

# المرحلة الثانية: التشغيل (تأكدي أن السطر 7 أصبح هكذا)
FROM amazoncorretto:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
# احذف السطر القديم واكتب هذا مكانه
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]