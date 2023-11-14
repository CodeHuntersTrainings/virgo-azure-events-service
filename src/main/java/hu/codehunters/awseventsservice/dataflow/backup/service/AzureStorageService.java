package hu.codehunters.awseventsservice.dataflow.backup.service;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import hu.codehunters.awseventsservice.dataflow.EventProcessor;
import hu.codehunters.awseventsservice.service.model.Event;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.io.ByteArrayInputStream;

@Slf4j
@Component
@Profile("backup")
public class AzureStorageService implements EventProcessor {

    private final BlobContainerClient blobContainerClient;

    private final ObjectMapper objectMapper;

    private final Counter storedDataCounter;

    public AzureStorageService(BlobContainerClient blobContainerClient,
                               ObjectMapper objectMapper,
                               MeterRegistry meterRegistry) {
        this.blobContainerClient = blobContainerClient;
        this.objectMapper = objectMapper;
        this.storedDataCounter = meterRegistry.counter("events.storedAsBlob");
    }

    @Override
    public void process(Event event) {
        log.info("Event {} has been received", event.getEventId());

        try {
            saveEvent(event);
            storedDataCounter.increment();
            log.info("Event {} has been saved", event.getEventId());

        } catch (Exception e) {
            log.error("Saving event {} failed", event, e);

        }
    }

    private void saveEvent(Event event) throws JsonProcessingException {
        String fileName = event.getEventId() + ".json";
        String jsonString = objectMapper.writeValueAsString(event);
        byte[] data = jsonString.getBytes();

        BlobClient blobClient = blobContainerClient.getBlobClient(fileName);

        blobClient.upload(new ByteArrayInputStream(data), data.length, true);
    }

}
