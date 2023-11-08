FROM --platform=linux/amd64 openjdk:17-alpine
COPY ./target/azure-events-service-*.jar service.jar
EXPOSE 8080
ENV CONFIG_ENV=backup
ENTRYPOINT java -jar -Dspring.profiles.active=${CONFIG_ENV} service.jar