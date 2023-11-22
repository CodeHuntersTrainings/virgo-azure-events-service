package hu.codehunters.awseventsservice.dataflow.reporting.repository;

import hu.codehunters.awseventsservice.service.model.Event;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

@Document(value = "events")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class EventDocument {
    private String eventId;
    private String eventType;
    private Instant timestamp;
    private String userId;
    private Event data;
}
