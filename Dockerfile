# المرحلة الأولى: بناء التطبيق
FROM gradle:8.14-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle bootJar --no-daemon -x test

# المرحلة الثانية: التشغيل (تعديل ليدعم الكابتشا والرموز)
FROM amazoncorretto:17-alpine
WORKDIR /app

# خطوة حاسمة: تثبيت مكتبات الرسم والخطوط (بدونها لن تظهر الحروف)
RUN apk add --no-cache fontconfig ttf-dejavu

COPY --from=build /app/build/libs/*.jar app.jar

# إضافة إعدادات الـ Headless التي تسمح لـ Java برسم الحروف في الخلفية
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "app.jar"]