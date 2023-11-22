package hu.codehunters.awseventsservice.dataflow.reporting.repository;

import org.springframework.context.annotation.Profile;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
@Profile("reporting")
public interface EventRepository extends MongoRepository<EventDocument, String> {
}
