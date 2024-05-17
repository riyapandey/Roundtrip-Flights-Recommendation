# Function to identify the top n busiest roundtrip routes based on the number of flights
find_busiest_routes <- function(data, top_n = 10) {
  data %>%
    count(ROUNDTRIP_ROUTE) %>%
    mutate(TOTAL_FLIGHTS = n / 2) %>% # Adjust count for roundtrips
    arrange(desc(TOTAL_FLIGHTS)) %>%
    slice_head(n = top_n) %>%
    transmute(ROUNDTRIP_ROUTE, TOTAL_ROUNDTRIP_FLIGHTS = as.integer(TOTAL_FLIGHTS))
}


# Function to calculate financial metrics such as costs, revenues, and profits for each route
calculate_financial_metrics <- function(data) {
  data %>%
    mutate(
      # Calculate total passengers for a round trip considering occupancy rate
      PASSENGERS_ROUNDTRIP = OCCUPANCY_RATE * 200 * 2,
      
      # Double the distance for round trips as flights go to the destination and return
      DISTANCE_ROUNDTRIP = DISTANCE * 2,
      
      # Delay cost calculations based on $75 per minute beyond the first 15 minutes
      DELAY_COST_DEP = if_else(DEP_DELAY > 15, (DEP_DELAY - 15) * 75, 0),
      DELAY_COST_ARR = if_else(ARR_DELAY > 15, (ARR_DELAY - 15) * 75, 0),
      DELAY_COST = DELAY_COST_DEP + DELAY_COST_ARR,
      
      # Fixed costs determined by airport type
      FIXED_COST = if_else(ORIGIN_AIRPORT_TYPE == "medium_airport", 5000, 10000) + 
        if_else(DESTINATION_AIRPORT_TYPE == "medium_airport", 5000, 10000),
      
      # Variable costs based on distance
      VARIABLE_COST_1 = DISTANCE_ROUNDTRIP * 8, # Costs for fuel, oil, and maintenance
      VARIABLE_COST_2 = DISTANCE_ROUNDTRIP * 1.18, # Costs for depreciation, insurance, etc.
      VARIABLE_COST = VARIABLE_COST_1 + VARIABLE_COST_2,
      
      # Total Cost Calculation
      TOTAL_COST = DELAY_COST + FIXED_COST + VARIABLE_COST,
      
      # Revenue calculations including tickets and baggage fees
      TICKETS_REVENUE = AVG_ITIN_FARE / 2   * PASSENGERS_ROUNDTRIP,
      BAGGAGE_FEE = PASSENGERS_ROUNDTRIP * 0.5 * 70,
      TOTAL_REVENUE = TICKETS_REVENUE + BAGGAGE_FEE,
      
      # Net Profit Calculation
      PROFIT = TOTAL_REVENUE - TOTAL_COST
    )
}


# Function to summarize and sort routes based on profitability
summarize_top_routes <- function(data, top_n = 10) {
  data %>%
    group_by(ROUNDTRIP_ROUTE) %>%
    summarise(
      TOTAL_ROUNDTRIP_FLIGHTS = n() / 2,
      TOTAL_REVENUE = sum(TOTAL_REVENUE),
      TOTAL_COST = sum(TOTAL_COST),
      TOTAL_PROFIT = sum(PROFIT),
      .groups = 'drop'
    ) %>%
    arrange(desc(TOTAL_PROFIT)) %>%
    slice_head(n = top_n)
}


# Function to process and summarize route data for making investment recommendations
process_and_summarize_routes <- function(data) {
  data %>%
    mutate(
      ON_TIME_DEP = ifelse(DEP_DELAY <= 15, 1, 0),  # 1 if departure is on-time
      ON_TIME_ARR = ifelse(ARR_DELAY <= 15, 1, 0)   # 1 if arrival is on-time  
    ) %>%
    group_by(ROUNDTRIP_ROUTE) %>%
    summarise(
      TOTAL_ROUNDTRIP_FLIGHTS = n()/2,
      TOTAL_PROFIT = sum(PROFIT),
      AVG_DELAY_COST = mean(DELAY_COST),
      AVG_REVENUE_TO_COST_RATIO = mean(TOTAL_REVENUE / TOTAL_COST),
      ON_TIME_DEP_PCT = sum(ON_TIME_DEP)/n() * 100,
      ON_TIME_ARR_PCT = sum(ON_TIME_ARR)/n() * 100,
      COMBINED_ON_TIME_PCT = (ON_TIME_DEP_PCT + ON_TIME_ARR_PCT) / 2,
      AVG_OCCUPANCY_RATE = mean(OCCUPANCY_RATE),
      .groups = 'drop'
    )
}


# Function to recommend routes based on profitability and performance indicators
recommend_routes <- function(data, top_n = 5) {
  data %>%
    arrange(
      # Prioritize routes based on several factors to make the best investment decisions
      desc(TOTAL_PROFIT), # Primary factor: Profitability
      desc(COMBINED_ON_TIME_PCT), # Secondary factor: Overall on-time performance
      desc(AVG_REVENUE_TO_COST_RATIO), # Tertiary factor: Efficiency in generating revenue against costs
      AVG_DELAY_COST, # Consider lower average delay costs
      desc(AVG_OCCUPANCY_RATE) # Higher occupancy rates are preferable
    ) %>%
    select(ROUNDTRIP_ROUTE, TOTAL_PROFIT, COMBINED_ON_TIME_PCT, AVG_REVENUE_TO_COST_RATIO,
           AVG_DELAY_COST, AVG_OCCUPANCY_RATE, TOTAL_ROUNDTRIP_FLIGHTS) %>% 
    head(top_n)
}


# Function to calculate the number of flights required to breakeven on airplane costs for recommended routes
calculate_breakeven <- function(data, airplane_cost) {
  data %>%
    mutate(
      PROFIT_PER_FLIGHT = TOTAL_PROFIT / TOTAL_ROUNDTRIP_FLIGHTS, # Profit per flight
      BREAKEVEN_FLIGHTS = ceiling(airplane_cost / PROFIT_PER_FLIGHT) # Flights needed to cover airplane costs
    ) %>%
    select(
      ROUNDTRIP_ROUTE,
      TOTAL_ROUNDTRIP_FLIGHTS,
      TOTAL_PROFIT,
      PROFIT_PER_FLIGHT,
      BREAKEVEN_FLIGHTS,
      COMBINED_ON_TIME_PCT,
      AVG_REVENUE_TO_COST_RATIO,
      AVG_DELAY_COST,
      AVG_OCCUPANCY_RATE
    )
}


