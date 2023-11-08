package hu.codehunters.awseventsservice.dataflow.backup.service;

import com.azure.core.util.BinaryData;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.models.BlobItem;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import hu.codehunters.awseventsservice.service.model.Event;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Profile;

import java.util.UUID;

@SpringBootTest
@Profile("backup")
class AzureStorageServiceTest {

    @Autowired
    private AzureStorageService underTest;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private BlobContainerClient blobContainerClient;

    @Test
    @Disabled
    void given_event_when_processed_then_must_be_put_on_azure_storage_v1() throws JsonProcessingException {
        // Given
        String eventId = UUID.randomUUID().toString();
        String targetFileName = eventId + ".json";

        String eventAsString = String.format("""
                {
                  "eventType": "AD_CREATED",
                  "timestamp": "2023-08-10T15:30:00Z",
                  "version": "v1",
                  "eventId": "%s",
                  "source": "ebay",
                  "traceId": "1234-abc-1234",
                  "data": {
                    "adId": "123",
                    "category": "house",
                    "userId": "user123",
                    "description": "This is a description ..."
                  }
                }
                """, eventId);



        Event input = objectMapper.readValue(eventAsString, Event.class);

        // When
        underTest.process(input);

        // Then
        BlobItem savedBlobItem = blobContainerClient.listBlobs().stream()
                .filter(blobItem -> targetFileName.equals(blobItem.getName()))
                        .findFirst().get();

        Assertions.assertNotNull(savedBlobItem);

        // Cleanup
        blobContainerClient.getBlobClient(targetFileName).delete();
    }

    @Test
    @Disabled
    void given_event_when_processed_then_must_be_put_on_azure_storage_v2() throws JsonProcessingException {
        // Given
        String eventId = UUID.randomUUID().toString();
        String targetFileName = eventId + ".json";

        String eventAsString = String.format("""
                {
                  "eventType": "AD_CREATED",
                  "timestamp": "2023-08-10T15:30:00Z",
                  "version": "v1",
                  "eventId": "%s",
                  "source": "ebay",
                  "traceId": "1234-abc-1234",
                  "data": {
                    "adId": "123",
                    "category": "house",
                    "userId": "user123",
                    "description": "This is a description ..."
                  }
                }
                """, eventId);



        Event input = objectMapper.readValue(eventAsString, Event.class);

        // When
        underTest.process(input);

        // Then
        BinaryData binaryData = blobContainerClient.getBlobClient(targetFileName).downloadContent();

        Assertions.assertNotNull(binaryData);

        // Cleanup
        blobContainerClient.getBlobClient(targetFileName).delete();
    }

}