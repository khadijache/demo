# المرحلة الأولى: بناء المشروع بنسخة Gradle المتوافقة
FROM gradle:8.14-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle bootJar --no-daemon -x test

# المرحلة الثانية: التشغيل وتثبيت مكتبات الرسم
FROM amazoncorretto:17-alpine
WORKDIR /app

# تثبيت الخطوط اللازمة لرسم حروف الكابتشا
RUN apk add --no-cache fontconfig ttf-dejavu

# نسخ ملف الـ Jar الناتج من مرحلة البناء
COPY --from=build /app/build/libs/*.jar app.jar

# تشغيل التطبيق في وضع headless (بدون شاشة)
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]