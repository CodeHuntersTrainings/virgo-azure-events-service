package hu.codehunters.awseventsservice.dataflow.backup.configuration;

import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile("backup")
public class AzureStorageConfiguration {

    @Bean
    public BlobServiceClient blobServiceClient(@Value("${events-service.flows.backup.storage.connection-string}") String connectionString) {
        return new BlobServiceClientBuilder()
                .connectionString(connectionString)
                .buildClient();
    }

    @Bean
    public BlobContainerClient blobContainerClient(BlobServiceClient blobServiceClient,
                                                   @Value("${events-service.flows.backup.storage.container-name}") String containerName) {
        return blobServiceClient.getBlobContainerClient(containerName);
    }

}
