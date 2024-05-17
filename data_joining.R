# Function to efficiently join and process flight, airport codes, and ticket datasets into a comprehensive dataset
process_flight_data <- function(flights, airport_codes, tickets) {
  # Join for Origin airport information first and then join for Destination airport information
  flights_airport_codes <- flights %>%
    inner_join(airport_codes, by = c("ORIGIN" = "IATA_CODE")) %>% 
    inner_join(airport_codes, by = c("DESTINATION" = "IATA_CODE"), suffix = c(".origin", ".destination")) %>% 
    # Rename and select relevant columns to streamline the dataset
    rename(ORIGIN_AIRPORT_TYPE = TYPE.origin, ORIGIN_AIRPORT_NAME = NAME.origin, 
           ORIGIN_MUNICIPALITY = MUNICIPALITY.origin, DESTINATION_AIRPORT_TYPE = TYPE.destination,
           DESTINATION_AIRPORT_NAME = NAME.destination, 
           DESTINATION_MUNICIPALITY = MUNICIPALITY.destination, LATITUDE_ORIGIN = LATITUDE.origin,
           LONGITUDE_ORIGIN = LONGITUDE.origin, LATITUDE_DESTINATION = LATITUDE.destination,
           LONGITUDE_DESTINATION = LONGITUDE.destination) %>% 
    select(FL_DATE, OP_CARRIER, TAIL_NUM, OP_CARRIER_FL_NUM, ORIGIN, ORIGIN_CITY_NAME, DESTINATION, DEST_CITY_NAME, 
           DEP_DELAY, ARR_DELAY, AIR_TIME, DISTANCE, OCCUPANCY_RATE, ORIGIN_AIRPORT_TYPE,
           ORIGIN_AIRPORT_NAME, ORIGIN_MUNICIPALITY, DESTINATION_AIRPORT_TYPE, 
           DESTINATION_AIRPORT_NAME, DESTINATION_MUNICIPALITY, LATITUDE_ORIGIN, LONGITUDE_ORIGIN,
           LATITUDE_DESTINATION, LONGITUDE_DESTINATION)
  
  # Aggregate ticket data to obtain average fare per route
  tickets_aggregated <- tickets %>%
    mutate(ROUNDTRIP_ROUTE = pmap_chr(list(ORIGIN, DESTINATION),
                                      ~paste(sort(c(...)), collapse = "-"))) %>%
    group_by(ORIGIN, DESTINATION, REPORTING_CARRIER, ROUNDTRIP_ROUTE) %>%
    summarise(AVG_ITIN_FARE = mean(ITIN_FARE), .groups = 'drop')
  
  # Join the flights data with aggregated ticket data for comprehensive analysis
  final_data <- flights_airport_codes %>%
    inner_join(tickets_aggregated, by = c("ORIGIN" = "ORIGIN", "DESTINATION" = "DESTINATION", 
                                          "OP_CARRIER" = "REPORTING_CARRIER"))
  return(final_data)
}



