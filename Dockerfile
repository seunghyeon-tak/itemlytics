# build 단계
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY . .
RUN ./gradlew -x test clean bootJar

# run 단계
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
ENV SPRING_PROFILES_ACTIVE=prod
HEALTHCHECK --interval=10s --timeout=3s --retries=6 CMD wget -q0- http://localhost:8080/actuator/health | grep '"UP"' || exit 1
EXPOSE 8080
USER 1000
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-jar", "/app/app.jar"]