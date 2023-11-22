package hu.codehunters.awseventsservice.dataflow.collector.configuration;

import com.azure.core.credential.AzureKeyCredential;
import com.azure.messaging.eventgrid.EventGridEvent;
import com.azure.messaging.eventgrid.EventGridPublisherClient;
import com.azure.messaging.eventgrid.EventGridPublisherClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile("collector")
public class AzureEventGridConfiguration {

    @Bean
    public EventGridPublisherClient<EventGridEvent> eventGridPublisherClient(
            @Value("${events-service.flows.collector.queue.topic-endpoint}") String topicEndpoint,
            @Value("${events-service.flows.collector.queue.topic-access-key}") String topicAccessKey
    ) {

        return new EventGridPublisherClientBuilder()
                .endpoint(topicEndpoint)
                .credential(new AzureKeyCredential(topicAccessKey))
                .buildEventGridEventPublisherClient();
    }

}
