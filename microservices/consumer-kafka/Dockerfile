FROM maven:3.6-jdk-12-alpine as build       

WORKDIR /app

COPY pom.xml .
COPY src src

RUN mvn clean package

FROM openjdk:12-alpine

COPY --from=build \
    /app/target/testconsumer-1.0.0-jar-with-dependencies.jar \
    /app/target/testconsumer-app-1.0.0.jar

ENTRYPOINT ["java", "-jar", "/app/target/testconsumer-app-1.0.0.jar"]