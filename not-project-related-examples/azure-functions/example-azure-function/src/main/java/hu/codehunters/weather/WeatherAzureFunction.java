package hu.codehunters.weather;

import com.microsoft.azure.functions.annotation.*;
import com.microsoft.azure.functions.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class WeatherAzureFunction {

    private final Map<String, WeatherData> weatherDataByLocation = new HashMap<>();

    public WeatherAzureFunction() {
        weatherDataByLocation.put("Hungary", new WeatherData(24, 120, 5D, 1));
        weatherDataByLocation.put("Germany", new WeatherData(15, 99, 1D, 2));
        weatherDataByLocation.put("Italy", new WeatherData(30, 70, 10D, 5));
    }

    /**
     * This function listens at endpoint "/api/weather". Two ways to invoke it using "curl" command in bash:
     * 1. curl -d "HTTP Body" {your host}/api/weather
     * 2. curl {your host}/api/weather?location=HTTP%20Query
     */
    @FunctionName("weather")
    public HttpResponseMessage run(
            @HttpTrigger(name = "req", methods = {HttpMethod.GET, HttpMethod.POST}, authLevel = AuthorizationLevel.FUNCTION) HttpRequestMessage<Optional<String>> request,
            final ExecutionContext context) {
        context.getLogger().info("Java HTTP trigger processed a request.");

        // Parse query parameter
        String location = request.getQueryParameters().get("location");

        if (location == null) {
            return request.createResponseBuilder(HttpStatus.BAD_REQUEST).body("Please pass a name on the query string.").build();
        } else {
            return request.createResponseBuilder(HttpStatus.OK).body(weatherDataByLocation.get(location)).build();
        }
    }
}
