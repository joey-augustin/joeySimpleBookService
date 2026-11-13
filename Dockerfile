
FROM amazoncorretto:17-al2023-jdk AS builder
WORKDIR /workspace/app
RUN dnf install -y findutils && dnf clean all
 
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./
 
RUN chmod +x gradlew
 
RUN ./gradlew build -x test --no-daemon || true
 
COPY src src
 
RUN ./gradlew bootJar -x test --no-daemon
 
RUN java -Djarmode=layertools -jar build/libs/*.jar extract --destination build/extracted
 
FROM amazoncorretto:17-al2023-headless AS runner
WORKDIR /app
 
USER 1001:1001
 
 
COPY --from=builder /workspace/app/build/extracted/dependencies/ ./
COPY --from=builder /workspace/app/build/extracted/spring-boot-loader/ ./
COPY --from=builder /workspace/app/build/extracted/snapshot-dependencies/ ./
COPY --from=builder /workspace/app/build/extracted/application/ ./
 
EXPOSE 8080
 
ENTRYPOINT ["java", "-XX:+UseG1GC", "-XX:+ExitOnOutOfMemoryError", "org.springframework.boot.loader.launch.JarLauncher"]