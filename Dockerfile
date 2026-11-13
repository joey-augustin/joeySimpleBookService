FROM amazoncorretto:17-al2023-jdk AS builder
WORKDIR /workspace/app

RUN dnf install -y findutils && dnf clean all

COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon

COPY src src
RUN ./gradlew bootJar -x test --no-daemon
RUN find build/libs -name "*.jar" ! -name "*-plain.jar" -exec cp {} app.jar \;

FROM amazoncorretto:17-al2023-headless AS runner
WORKDIR /app

COPY --from=builder /workspace/app/app.jar app.jar

USER 1001:1001
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]