# Stage 1: Build (multi-stage for efficiency, but simple single-stage here)
FROM maven:3.9.6-openjdk-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests  # Builds the JAR; adjust module if needed

# Stage 2: Runtime
FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar  # Assumes JAR is in target/; update path for your module
EXPOSE 8080  # Expose port if your app listens on 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
