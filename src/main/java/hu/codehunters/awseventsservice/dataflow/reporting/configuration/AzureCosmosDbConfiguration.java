package hu.codehunters.awseventsservice.dataflow.reporting.configuration;

import hu.codehunters.awseventsservice.dataflow.reporting.repository.EventRepository;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@EnableMongoRepositories(basePackageClasses = EventRepository.class)
@Configuration
@Profile("reporting")
public class AzureCosmosDbConfiguration {
}
