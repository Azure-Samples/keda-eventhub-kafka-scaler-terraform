FROM maven:3.6-jdk-12-alpine as build       

WORKDIR /app

COPY pom.xml .
COPY src src

RUN mvn clean compile assembly:single

FROM openjdk:12-alpine

COPY --from=build \
    /app/target/testconsumereph-1.0.0-jar-with-dependencies.jar \
    /app/target/testconsumereph-app-1.0.0.jar

ENTRYPOINT ["java", "-jar", "/app/target/testconsumereph-app-1.0.0.jar"]