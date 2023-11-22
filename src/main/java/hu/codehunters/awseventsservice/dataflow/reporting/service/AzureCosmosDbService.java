package hu.codehunters.awseventsservice.dataflow.reporting.service;

import hu.codehunters.awseventsservice.dataflow.EventProcessor;
import hu.codehunters.awseventsservice.dataflow.reporting.repository.EventDocument;
import hu.codehunters.awseventsservice.dataflow.reporting.repository.EventRepository;
import hu.codehunters.awseventsservice.exception.MissingUserIdException;
import hu.codehunters.awseventsservice.exception.UnableToSaveUserEventException;
import hu.codehunters.awseventsservice.service.model.Event;
import hu.codehunters.awseventsservice.service.model.EventType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.util.EnumSet;

@Slf4j
@Component
@Profile("reporting")
public class AzureCosmosDbService implements EventProcessor {

    private static final String userIdFieldName = "userId";

    private static final EnumSet<EventType> ACCEPTED_EVENTS = EnumSet.of(
            EventType.USER_CREATED,
            EventType.USER_DELETED
    );

    private final EventRepository repository;

    public AzureCosmosDbService(EventRepository eventRepository) {
        this.repository = eventRepository;
    }

    @Override
    public void process(Event event) {
        if (!ACCEPTED_EVENTS.contains(event.getEventType())) {
            //We simply ignore the irrelevant messages
            log.warn("Unsupported Event Type in Reporting Data Flow");
            return;
        }

        if (!event.getData().containsKey(userIdFieldName)) {
            log.error("Unable to process event {} in Reporting, userId missing.", event.getEventId());
            throw new MissingUserIdException("Unable to process event in Reporting, userId missing.");
        }

        saveDataToRds(event);

        log.info("Number of all events in the database: {}", repository.count());
    }

    private void saveDataToRds(Event event) {
        try {
            EventDocument eventDocument = new EventDocument();
            eventDocument.setEventId(event.getEventId());
            eventDocument.setEventType(event.getEventType().name());
            eventDocument.setTimestamp(event.getTimestamp());
            eventDocument.setUserId((String) event.getData().get(userIdFieldName));
            eventDocument.setData(event);

            repository.save(eventDocument);

        } catch (Exception e) {
            log.error("Unable to save event {} in Reporting.", event.getEventId());
            throw new UnableToSaveUserEventException("Unable to save event in Reporting.", e);
        }
    }
}
