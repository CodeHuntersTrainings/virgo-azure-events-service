package hu.codehunters.awseventsservice.dataflow.collector.service;

import com.azure.core.util.BinaryData;
import com.azure.messaging.eventgrid.EventGridEvent;
import com.azure.messaging.eventgrid.EventGridPublisherClient;
import hu.codehunters.awseventsservice.dataflow.EventProcessor;
import hu.codehunters.awseventsservice.service.model.Event;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@Profile("collector")
public class AzureEventGridService implements EventProcessor {
    private final EventGridPublisherClient<EventGridEvent> eventGridPublisherClient;

    public AzureEventGridService(EventGridPublisherClient<EventGridEvent> eventGridPublisherClient) {
        this.eventGridPublisherClient = eventGridPublisherClient;
    }

    @Override
    public void process(Event event) {
        log.info("Event {} has been received", event.getEventId());

        try {
            sendEvent(event);
            log.info("Event {} has been sent", event.getEventId());

        } catch (Exception e) {
            log.error("Sending event {} failed", event, e);
            throw new RuntimeException(e);
        }
    }

    private void sendEvent(Event event) {
        EventGridEvent eventGridEvent = new EventGridEvent(
                "CodeHuntersEvents",
                "Microsoft.Resources.ResourceWriteSuccess",
                BinaryData.fromObject(event),
                "v1"
        );

        eventGridPublisherClient.sendEvent(eventGridEvent);
    }
}
