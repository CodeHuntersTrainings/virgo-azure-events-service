FROM --platform=linux/amd64 openjdk:17-alpine
COPY ./target/azure-events-service-*.jar service.jar
EXPOSE ???
ENV CONFIG_ENV=???
ENTRYPOINT java -jar -Dspring.profiles.active=${CONFIG_ENV} ???