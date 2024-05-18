
                                                
                                                FLIGHT ROUNDTRIP RECOMMENDATIONS
<p align="center">
  <img width="500" alt="image" src="https://github.com/riyapandey/Roundtrip-Flights-Recommendation/assets/11988564/b6d74a39-898c-4312-8213-50ce39049718">
</p>

----------------------------------------------------------------------------------------------------------
CONTENTS:
1. Overview
2. Methodology
3. Libraries Used
4. Functions 
    a) Data Manipulation Functions
    b) Visualization Functions
    c) Statistical Functions
5. Flights Dataset
    a) Cleaning and Preprocessing
    b) Missing Data Management
    c) Statistical Analysis and Visualization
    d) Outlier Management
    e) Descriptive Statistics
6. Tickets Dataset
    a) Cleaning and Preprocessing
    b) Missing Data Management
    c) Statistical Analysis and Visualization
    d) Outlier Management
    e) Descriptive Statistics
7. Airport_Codes Dataset
    a) Cleaning and Preprocessing
    b) Missing Data Management
    c) Descriptive Statistics
8. Summary of some Data Quality Insights
9. Summary of some Data Outliers
10. Data Joining
11. Task 1
    a) Interpretation of Visualisation Results
    b) Key Trends Observed
12. Task 2
    a) Interpretation of Visualisation Results
    b) Key Trends Observed
13. Task 3
    a) Interpretation of Visualisation Results
    b) Key Trends Observed
14. Task 4
    a) Interpretation of Visualisation Results
    b) Key Trends Observed
15. Task 5
16. Overall Key Trends and Insights
17. Recommended Routes
18. Recommendations
19. Conclusion
20. Next Steps for Better Decision Making
---------------------------------------------------------------------------------------------------------

Overview:
This document provides an in-depth analysis for an airline planning to launch domestic routes in the United States. It uses data from the first quarter of 2019 to identify the busiest and most profitable routes, recommend investment opportunities, and calculate the breakeven points for selected routes. This analysis aligns with the company’s motto “On time, for you”, prioritizing punctuality and operational efficiency to enhance the airline's brand image and financial success.

Methodology: 
Utilized three key datasets — Flights, Tickets, and Airport Codes. A detailed analysis was conducted on round trip flights. The approach involved:
- Identifying the top 10 busiest and most profitable round trip routes.
- Recommending five round trip routes for investment based on profitability, on-time performance, and operational efficiency.
- Calculating the break-even point in terms of the number of flights for each recommended route.
- Proposing Key Performance Indicators (KPIs) to track the success of these routes.

Libraries Used:
Tidyverse: A collection of R packages for data manipulation and visualization.
Lubridate: Simplifies dealing with dates and times.
Ggrepel: Helps in adjusting text positions in plots to prevent overlap.
Scales: Used for formatting plot labels and axes.
GridExtra: Facilitates the creation of complex, custom multi-panel figures.
Reshape2: Allows reshaping of data between wide and long formats.

Functions:

Data Manipulation Functions:
read_data: Reads CSV files into R, ensuring that all strings that should be 'NA' are recognized as R's NA values.
extract_unique_non_alphanumeric_parts: Identifies unexpected non-numeric characters in numeric fields, which could indicate data entry errors.
convert_numeric: Converts specified columns to numeric types, removing any non-numeric characters.
parse_dates: Converts date columns to a consistent format using the lubridate package.
convert_year_to_date: Converts a year column to a full date format, setting a standard starting point for the year.
convert_to_character: Converts specified columns to character data types.
coordinates_conversion: Converts a coordinates column into separate longitude and latitude columns.
handle_na_nan: Standardizes the treatment of missing values by converting 'NaN' to 'NA'.
to_positive: Converts negative numbers in specified columns to positive, useful in contexts where negatives do not make sense.
check_na_and_empty_strings: Checks and summarizes NA and empty string values in numeric and character columns, respectively. Provides a clear overview of missing data, guiding data cleaning and imputation strategies.
impute_missing_values: Imputes missing values based on the median of the specified group or the overall median if group imputation is insufficient.
na_proportions: Decides on data imputation or removal based on the proportion of NA values in a column.
impute_based_on_correlation: Imputes missing values in column2 based on correlation with column1.
filter_out_nas: Filters out NA values from specified columns.
character_columns_nas: Filters out null or empty values from character columns.
remove_duplicates: Removes duplicate entries from the dataset to prevent skewing of results.

Visualization Functions
plot_bar: Creates customizable bar plots with options for flipping coordinates, adding text labels, and using dollar formatting.
plot_scatter_label: Creates scatter plots with labels, useful for identifying patterns and outliers in two-dimensional data.
plot_segment: Generates segment plots, particularly useful for visualizing ranges or distributions along a single axis.
plot_pie_chart: Creates pie charts with labels for visualization.

Statistical Functions
calculate_skewness, plot_histograms: These functions calculate and visualize the skewness of data distributions, providing insights into the symmetry of data distribution.
find_outliers, plot_boxplots: Identify and visualize outliers in data, which are critical for understanding data variability and potential data issues. Helps in detecting anomalies that could affect analyses and decision-making.
cap_outliers: Caps outliers at specified percentiles to mitigate the impact of extreme values on the analysis. Prevents extreme values from skewing results, thereby maintaining the reliability of statistical inferences.

1. Flights Dataset

Data Preprocessing and Cleaning:
- Imported the flights dataset for analysis.
- Excluded cancelled flights, as instructed.
- Addressed non-alphanumeric values found in the 'DISTANCE' and 'AIR_TIME' columns.
- Converted the 'FL_DATE' to a consistent date format across the dataset.
- Changed the data types of 'DISTANCE' and 'AIR_TIME' from character to numeric to facilitate numerical operations.
- Replaced NaN values in 'AIR_TIME' and 'DISTANCE' with NAs for uniformity in missing value handling within R, which treats NA and NaN differently.
- Corrected negative values in 'AIR_TIME' and 'DISTANCE' by converting them to their positive equivalents, assuming these were due to data entry errors.

Missing Data Management:
- Conducted a thorough check for NA values in numeric columns and null values in string columns.
- Visualized the count of the NA values and null values through bar graphs. 'AIR_TIME', 'ARR_DELAY', 'DISTANCE', and 'OCCUPANCY_RATE' had Na's in the dataset. There were no null values in the character columns.
- Imputed NA values in 'AIR_TIME' and 'DISTANCE' by calculating the median for each route grouped by 'ORIGIN' and 'DESTINATION'. This method was chosen as it reflects the typical conditions of flight times and distances, which are less prone to variation barring factors like weather or traffic conditions.
- For 'OCCUPANCY_RATE', removed NA values when their proportion was less than 5%. For proportions greater than 5%, values were imputed by the median occupancy rate grouped by 'ORIGIN' and 'DESTINATION' to reflect regional trends.
- Imputed missing 'ARR_DELAY' values using the median of 'DEP_DELAY' for flights with recorded arrival delays, leveraging the correlation between departure and arrival delays.
- Identified and removed approximately 4,121 duplicate entries.

Statistical Analysis and Visualization:
- Calcualted the skewness for the numeric variables and visualized them using histograms.
- 'DEP_DELAY' and 'ARR_DELAY' exhibited a moderate right skew, indicating that most flights are on time or have minor delays, but there are some with significant delays. 
- Looking at the histogram:
Departure Delays (DEP_DELAY): The skewness calculation and histogram suggests that the skewness is positive but less than 1, suggesting a moderate right-skewed distribution. This indicates that while most flights depart on time or slightly delayed, there are a number of flights with significant delays. 
Arrival Delays (ARR_DELAY): Also right-skewed, similar to departure delays. 
Air Time (AIR_TIME): Skewness indicates a moderately right-skewed distribution 
Distance (DISTANCE): Also shows a moderate right skew. 
Occupancy Rate (OCCUPANCY_RATE): The skewness is very close to zero, which indicates a nearly symmetrical distribution, suggesting consistent occupancy rates across flights. 
- Calcluated outliers and created box plots to identify outliers in numeric variables.
- There were significant outliers in a few columns, such as: 
Departure delays ('DEP_DELAY') within -25.50 to 26.50 minutes are normal. Instances beyond this range are outliers, signifying significantly early or delayed flights. There were departure delays more than 2000 minutes, which was assumed not possible, unless it was canclled. The boxplot reveals a median very close to zero with a few points representing extreme delays
Arrival delays ('ARR_DELAY') show a broader range than departures, with -49.50 to 42.50 minutes as typical. Values outside suggest unusually timed arrivals. The maximum value for ARR_DELAY was 2923 which was out of bounds. The boxplot confirms that the central tendency of arrival delays is close to the scheduled time, with outliers indicating some flights have been much later than expected.
Flight durations ('AIR TIME') are generally expected between -61.00 and 259.00 minutes from the median, especially for domestic flights. Durations outside this range are unusual. 
Typical flight distances ('DISTANCE') show to be expected between -659.5 and 2016.60, but the negative lower bound is not possible. The maximum value for DISTANCE was 9898 miles which does not seem possible for domestic flights.

Outlier Management:
- Noted significant outliers in 'DEP_DELAY', 'ARR_DELAY', 'AIR_TIME' and 'DISTANCE'. For example, 'DEP_DELAY' and 'ARR_DELAY' recorded extreme maximums of 2,941 minutes and 2,923 minutes, respectively, and improbable minimums of -63 minutes and -94 minutes. The 'DISTANCE' ranged from a minimum of 2 miles to a maximum of 9,898 miles.
- Addressed these outliers by capping values at the 1st and 99th percentiles, mitigating the influence of extreme data points. 

Descriptive Statistics: 
- Utilized the summary() function to obtain descriptive statistics of the dataset, providing insights into central tendency and dispersion.
- Looking at the summary, the ranges for all variables have decreased significantly, with departure and arrival delays now having a maximum of just over 200 minutes. This means that the capping has removed the extreme delays from the dataset. Similarly, the air time and distance now have more reasonable maximum values.

2. Tickets Dataset

Data Preprocessing and Cleaning:
- Imported the tickets dataset for comprehensive analysis.
- Restricted the analysis to only roundtrip tickets, as instructed.
- Converted the 'YEAR' column to a date format, anticipating future dataset enhancements or modifications, despite it currently containing uniform values.
- Transformed the 'QUARTER' column to a character data type for easier comparison and manipulation.

Missing Data Management: 
- Conducted an assessment for NA values in numeric columns and null values in string columns to ensure data integrity.
- Visualized the count of the NA values and null values through bar graphs. Numeric columns such as 'PASSENGERS' and 'ITIN
_FARE' had missing values. 
- Evaluated the proportion of missing values in the 'PASSENGERS' column. Similar to previous strategies with 'OCCUPANCY_RATE', decisions to impute or remove data were based on whether missing values exceeded a 5% threshold. Missing values were imputed with the median number of passengers grouped by 'ORIGIN' and 'DESTINATION' for proportions above 5%, to accurately reflect typical passenger counts for each route and capture regional trends.
- Found missing values in 'ITIN_FARE' which, considering its importance as a measure of revenue, were imputed based on median values grouped by 'ORIGIN' and 'DESTINATION'. This approach aimed to maintain consistency with route-specific pricing dynamics.
-Identified and removed approximately 47,327 duplicate entries, enhancing the dataset's accuracy and reliability.

Statistical Analysis and Visualization:
- Calculated skewness and plotted histograms to analyze the skewness of numeric variables, gaining insights into data distribution.
- 'ITIN_FARE' (Skewness: 0.5049942) shows moderate right skewness, indicating that while most tickets are at the lower to midrange fare, there are some tickets with a very high cost.
- The skewness of 'PASSENGERS' (Skewness: 0.5597480) is positive and indicating a moderate right skew. 
- Calculated outliers and created box plots to detect and examine outliers in numeric variables.
- The calculated bounds for 'ITIN_FARE' outliers were -195 to 1069. This indicates that most fares are expected to fall within this range, and fares outside of this may be considered unusually high or low. However, it had extreme values which was way out of bounds, which was needed to take care of. 
- The outlier calculation indicates bounds of 1 to 1 for PASSENGERS. In a dataset representing typical passenger counts for commercial flights, having a substantial number of flights with just one passenger is unusual. It could indicate data recording practices that flag flights with low occupancy distinctly, or it could be an artifact of how certain types of flights are reported in the dataset (e.g., repositioning flights, charter flights, or data entry errors).

Descriptive Statistics:
- Utilized the summary() function to obtain a broad statistical overview of the dataset, focusing on central tendencies and variability.
- The summary showed that:
ITIN_FARE: Post-capping, the maximum fare has been reduced to $1655 from values that may have been significantly higher, eliminating extreme high fares which likely included anomalies or luxury service fares.
PASSENGERS: The mean slightly increased, and the maximum number of passengers is now capped at 17, suggesting that the dataset might have included group bookings or larger party bookings that are now removed from the dataset, simplifying the overall analysis.

Outlier Management:
- Noted significant outliers in 'PASSENGERS' and 'ITIN_FARE', with extreme cases reaching up to 681 passengers and $38,400 in fare respectively. Chose not to remove entries showing a fare of $0.0, attributing them to potential free ticket issues under promotional offers, loyalty rewards, compensation for inconveniences, or full refunds on cancellations/no-shows aligned with airline policies.
- Addressed these outliers by capping them at the 1st and 99th percentiles. This method helps to mitigate the impact of extreme values on the statistical analyses and ensures the data remains representative for further analysis or predictive modeling. 

3. Airport_Codes dataset:

Data Preprocessing and Cleaning:
- Imported the airport_codes dataset for detailed analysis.
- Filtered the dataset to include only airports located in the United States, focusing specifically on medium and large airports. 
- Converted the 'COORDINATES' column into separate 'LONGITUDE' and 'LATITUDE' columns to facilitate interactive visualizations.

Missing Data Assessment:
- Conducted a thorough check for NA values in numeric columns and null values in string columns to ensure data integrity.
- Visualized the count of the NA values and null values through bar graphs. Numeric column like 'ELEVATION_FT' has some missing values. Character columns like 'MUNICIPALITY' and 'IATA_CODE' had missing values.
- Observed that the 'CONTINENT' column contained only null values, which was deemed irrelevant and ignored due to the dataset being restricted to the US.
- Identified minimal NA values in the 'ELEVATION_FT' column and opted to exclude these records from analysis, considering the limited impact on the overall dataset utility.
- Removed records lacking 'IATA_CODE' since these codes are essential identifiers within the aviation industry and cannot be accurately imputed.
- Decided against imputing missing 'MUNICIPALITY' values due to the absence of a reliable method for estimating this data based on other dataset variables.

Summary of some Data Quality Insights:
- During preprocessing, columns like 'DISTANCE' and 'AIR_TIME' initially contained non-numeric values and were inconsistently formatted across the dataset. This required converting these fields from character to numeric types to facilitate accurate calculations and analysis.
- Significant effort was directed towards managing NA values, particularly in critical fields like 'AIR_TIME', 'DISTANCE', and 'ITIN_FARE'. This was handled through strategies like median imputation within grouped data (by 'ORIGIN' and 'DESTINATION').
- Negative values in 'AIR_TIME' and 'DISTANCE', which are logically impossible, were corrected by converting them to positive values. 

Summary of some Data Outliers:
- Both 'ARR_DELAY' and 'DEP_DELAY' showed instances of values exceeding the reasonable upper bounds set by our analysis. These values were capped at the 1st and 99th percentiles to mitigate the influence of extreme and potentially erroneous data points. These adjustments were crucial in maintaining a balanced view of typical airline operations without the skew from extraordinary delay incidents.
- Itinerary Fares ('ITIN_FARE') observed significant outliers with fares reaching as high as $38,400 and as low as $0.0. These extreme values could potentially skew the average fare calculations and impact financial forecasting. The presence of zero fares might indicate special promotions, compensation, or data entry errors, while very high fares could suggest luxury or special charter flights. Addressing these outliers was crucial for maintaining accurate and meaningful financial analyses.
- The data revealed flights covering distances ('DISTANCE') ranging from as minimal as 2 miles to as extensive as 9,898 miles. These values were also capped at the 1st and 99th percentiles, accommodating typical flight routes while excluding extreme long-distance flights that are not representative of regular traffic.
- 'AIR_TIME' had an upper bound of 259, and in the data, they had the maximum value of 2222 which seems highly unlikely. This observation of a maximum air time greatly exceeding typical flight durations seemed unusual so these values were capped as well.

Data Joining:
- Developed a specialized function designed to join and process data from the flights, airport_codes, and tickets datasets efficiently and effectively.
- Utilized the inner join method twice to merge the flights dataset with the airport_codes dataset. Inner joins were applied specifically to the 'ORIGIN' and 'DESTINATION' fields to ensure that every flight record corresponds to valid, recognized airports. 
- Inner joins ensure that only records with matching keys in both datasets are included in the result. This is crucial when dealing with flights and airports, as to ensure that every flight included in the analysis corresponds to a valid, recognized airport in the airport_codes dataset. 
- The first inner join enriches the flights data with details about the origin airport, while the second join appends information regarding the destination airport. Each airport's data enriches the flight record with specific attributes related to its start and end points, which are critical for comprehensive route analysis.
- Renamed several columns to more descriptive terms to enhance understandability and clarity of the dataset. Selected specific columns to focus the analysis on relevant data, simplifying the overall dataset structure.
- Aggregated the tickets dataset to compute the average 'ITIN_FARE' by route. This approach reduces the complexity associated with individual ticket prices and shifts the focus to broader trends per route. Aggregation prevents potential many-to-many join complexities, ensuring a straightforward relationship between flights and ticket data.
- Introduced a 'ROUNDTRIP_ROUTE' column, which combines 'ORIGIN' and 'DESTINATION' airport codes into a single, direction-agnostic identifier. This method treats bidirectional routes (e.g., A-B and B-A) as identical, promoting a holistic view of the route as a unified entity. This approach is key in aggregating and analyzing data in a manner that recognizes trips between two points as part of the same analytical entity, irrespective of travel direction.
- Performed an inner join between the flights dataset and the aggregated tickets data. This step ensures that the final dataset includes only those routes for which detailed flight information and corresponding ticket pricing are available, which is indispensable for conducting accurate profitability and economic analyses.
- Applied the developed function to derive the final integrated dataset, referred to as 'final_data'. This dataset is now prepared for subsequent analysis, equipped with comprehensive and relevant information necessary for informed decision-making and insightful analysis.
- Removed duplicates in final_data, if any. 

Task 1: The 10 busiest round trip routes in terms of number of round trip flights in the quarter.

- Developed a custom function (find_busiest_routes), aimed at analyzing flight data to identify the busiest round trip routes in terms of flight frequency during a specific quarter.
- Grouped the data by ROUNDTRIP_ROUTE, using a unified route identifier to aggregate and ensure accurate flight counts for each route.
- Calculated the total number of flights per route, then adjusted this figure by dividing by 2. This adjustment accounts for the bidirectional nature of round trip routes, ensuring that each route is accurately counted once, rather than twice (once for each direction).
- Sorted the routes based on the total flights in descending order to highlight those with the highest frequency, indicating routes with the most significant traffic and potential demand.

Interpretation of Visualisation results:
The bar chart identifies the routes with the highest number of round trip flights during the first quarter of 2019. High flight frequency typically indicates strong passenger demand and operational importance of these routes. For instance, the LAX-SFO route, with 4,170 round trips, suggests a major corridor of travel likely driven by business and tourism. Similarly, routes like LGA-ORD and LAS-LAX also show high traffic, pointing to their strategic importance for the airline network. This information is crucial for the airline as it indicates where resources and capacity are most utilized, guiding decisions on where to focus service enhancements or additional capacity.

Key Trends Observed:
- The analysis underscores the importance of major airport hubs like LAX, LGA, and ATL, which serve as critical nodes in the U.S. air travel network. These hubs are often involved in the busiest routes, underscoring their strategic importance.
- The mix of long-haul (e.g., JFK-LAX) and shorter regional routes (e.g., LAX-SFO, ATL-MCO) highlights the diverse passenger needs ranging from business travel between major cities to tourism or local travel.
- Specific routes such as HNL-OGG, which cater to inter-island travel in Hawaii, point to unique niche markets that could present opportunities for targeted service offerings.

Task 2: The 10 most profitable round trip routes (without considering the upfront airplane cost) in
the quarter. 

- Developed a function to compute crucial financial metrics for each flight, including total costs, total revenue, and profit. 
- PASSENGERS_ROUNDTRIP: Created to calculate the total number of passengers for a round trip by multiplying the occupancy rate by the plane's full capacity (200 passengers) and considering the return trip.
- DISTANCE_ROUNDTRIP: Accounts for the total distance traveled in a round trip by doubling the one-way distance.
- DELAY_COST_DEP and DELAY_COST_ARR: These variables estimate the cost of delays, charging $75 for every minute beyond the first 15 minutes, providing a comprehensive view of the financial impact of delays on a round trip.
- FIXED_COST: Calculates fixed airport operational costs for using medium or large airports.
- VARIABLE_COST: Computes variable costs related to fuel, maintenance, depreciation, and insurance, reflecting costs that vary with the distance flown.
- TOTAL_COST: Aggregates all costs associated with a round trip.
- TICKETS_REVENUE: Represents total revenue from ticket sales for a round trip flight, adjusting average fare calculations to account for bidirectional data.
- BAGGAGE_FEE: Calculates revenue from baggage fees charged to passengers.
- TOTAL_REVENUE: The sum of TICKETS_REVENUE and BAGGAGE_FEE.
- PROFIT: Determines the net profit from a round trip.
- Created summarize_top_routes, a function designed to aggregate and analyze the financial data of airline routes, identifying the top ten most profitable routes based on the calculated profit for each roundtrip route. This function groups data by the ROUNDTRIP_ROUTE column, which contains direction-agnostic identifiers, aggregates critical financial metrics, and sorts the routes by total profit in descending order.

Interpretation of Visualisation results:
The scatter plot provides a clear picture of which routes are not just popular but also most financially beneficial to the airline. For example, JFK-LAX tops the list with a total profit of approximately $250 million, supported by substantial total revenue. The profitability data, combined with the number of flights, revenue, and costs, helps identify routes that maximize financial returns. Routes like DCA-ORD and DCA-LGA also show strong profitability, suggesting efficient management and pricing strategies that capitalize on demand. This profitability assessment is pivotal for the airline to prioritize investments and marketing efforts, ensuring resources are allocated to the most lucrative routes. This visualization indicates that while some routes may not be the busiest, they effectively translate traffic into revenue, potentially due to higher fare prices or efficient cost management.

Key Trends Observed:
- Major hubs like JFK, LGA, ATL, and ORD continue to play a critical role in route profitability. Routes connecting these hubs are among the most profitable, highlighting the strategic importance of hub operations in the network.

Task 3: The 5 round trip routes that you recommend to invest in based on any factors that you
choose.

- Developed functions to analyze and select airline routes for potential investment. These functions assess a variety of performance metrics crucial for determining the operational and financial viability of routes.
- Introduced two new columns, ON_TIME_DEP and ON_TIME_ARR, to track whether each flight departed and arrived on time (within 15 minutes of the scheduled time). These metrics are vital for evaluating an airline's punctuality, aligning with the brand promise of "On time, for you."
- Utilized the arrange function to order round trip routes based on selected performance metrics, effectively prioritizing routes for potential investment.

The factors considered for route selection are:
- Profitability: Routes are first sorted by TOTAL_PROFIT in descending order, prioritizing routes that demonstrate the highest financial performance and capability to generate surplus revenue over costs.
- Overall On-Time Performance: Emphasizes routes with superior on-time performance, crucial for customer satisfaction and reducing costs associated with delays and compensations.
- Revenue to Cost Ratio: The Revenue to Cost Ratio serves as a key indicator of a route's financial efficiency, revealing how effectively an airline converts operational expenses into income. A higher ratio means the airline is earning more revenue for each dollar spent, indicating a route's strong performance and strategic advantage in the market. It's essential for ensuring that routes are not just busy, but also profitable.
-Average Delay Costs: Prefers routes with lower average delay costs, which are typically better managed and experience fewer operational disruptions.
- Occupancy Rate: Also known as the load factor, measures how many seats on a flight are filled with passengers compared to the total number of available seats. Popular routes with high occupancy rates usually mean more people are flying on those routes. This increased demand is often good for airlines because it can lead to higher profits and a more stable cash flow.

Interpretation of Visualisation results:
The bar chart shows selection of recommended routes is based on a multifaceted evaluation of profitability, on-time performance, revenue-to-cost efficiency, delay costs, and occupancy rates, where profitability and on-tie performance are ranked the highest and displayed in the visualization For example, JFK-LAX not only has high profitability but also an excellent on-time performance rate of approximately 84.37%, making it a reliable and financially sound route for investment.

The set of bar charts provides insights into various performance metrics that was considered to recommend the five roundtrip routes:

Total Profit: JFK-LAX stands out with the highest profit, significantly more than the other routes, which indicates strong revenue generation, possibly due to high demand or premium pricing strategies.

On-time %: This metric appears relatively consistent across all routes, indicating that operational performance regarding punctuality doesn’t significantly vary between them. This uniformity can suggest that customers can expect reliable service in terms of timeliness on these routes.

Average Delay Cost: There’s more variation here, with LAX-SFO incurring the highest delay costs. JFK-LAX shows the lowest delay costs, aligning with its high profitability and suggesting efficient operations.

Average Occupancy Rate: The rates are consistently high across all routes, indicating none are struggling to attract passengers. High occupancy is a good sign of route popularity and effective capacity management.

Avergae Revenue to Cost Ratio: JFK-LAX, while not the highest, still demonstrates a healthy ratio, suggesting that it's a financially sound route, confirming the previous analysis that it is a high-profit option.

The high average revenue-to-cost ratio, especially on routes like DCA-LGA, indicates that these routes are not just covering their operational costs but are doing so very efficiently, yielding more revenue per dollar of cost than other routes. This detailed analysis ensures that the recommended routes align with the airline’s operational goals and brand promise of punctuality ("On time, for you").

The pie chart illustrates the distribution of profits among different roundtrip routes for an airline. Each segment of the pie chart represents the percentage of total profits attributed to a specific route.
JFK-LAX: This route is the most profitable, making up 29.21% of total profits. This could indicate high passenger demand, higher fares, more frequent flights, or a combination of these factors leading to higher profitability on this route.
LAX-SFO: Following closely, this route accounts for 18.93% of the profits.
DCA-ORD: Holding 17.65% of profits, this suggests that the route is also a key revenue generator.
ATL-LGA: With 17.19% of the profits, followed by DCA-LGA at 17.01% of the profits.
For an airline, understanding which routes are most profitable can inform decisions about where to allocate resources, such as more flights, bigger planes, or promotional offers. It helps to identify which routes could be expanded or improved for better profitability.

Task 4: The number of round trip flights it will take to breakeven on the upfront airplane cost for
each of the 5 round trip routes that you recommend.

- Developed a function specifically designed to calculate the breakeven point in terms of the number of flights needed for the profit from each route to cover the upfront cost of an airplane.
- Computed PROFIT_PER_FLIGHT by dividing the total profit by the total number of round trip flights. This metric provides a clear understanding of the average profit generated by each flight on a route.
- Defined BREAKEVEN_FLIGHTS as the minimum number of flights required to recover the initial airplane cost. 
- Utilized the ceiling function to ensure that the calculation rounds up.
- Selected relevant columns that provide insightful information for reporting and further analytical assessments.

Interpretation of Visualisation results:
The breakeven analysis, as shown in bubble chart, shows how many flights each route needs to operate to recover the cost of a $90 million airplane. JFK-LAX, for example, requires about 1,143 round trips to breakeven, which is feasible considering its high total profit and number of flights. This kind of analysis is critical for financial planning and investment decisions, providing a clear metric for how long it will take to see a return on new aircraft. Routes like LAX-SFO, despite their high traffic, require more flights to breakeven due to lower profit per flight, indicating that not all busy routes are equally profitable.

Task 5: Key Performance Indicators (KPI’s) that you recommend tracking in the future to measure the success of the round trip routes that you recommend.

-Profit per Flight: Evaluates the profit generated by each round trip flight. This helps assess the overall profitability of each route, taking into account all REVENUES and COSTS associated with completing a round trip journey.
- On-Time Departure and Arrival Rates: Measures the percentage of flights departing and arriving within 15 minutes of their scheduled times. This aligns with the brand's commitment to punctuality.
- Occupancy Rate: Tracks the percentage of available seats filled on each flight. A higher occupancy rate suggests better revenue generation from ticket sales.
-Revenue per Available Seat Mile (RASM): Calculates the total revenue per mile flown per seat. This KPI helps assess how effectively revenue is generated relative to the capacity offered.
- Cost per Available Seat Mile (CASM): Computes the cost for each seat per mile. Monitoring this helps manage and optimize operational efficiency.
- Break-even Flights: Knowing how many flights are needed to recover the cost of the airplane investment on each route provides a clear picture of the route's financial risk and payback period. 
- Customer Satisfaction Scores: Direct feedback from passengers regarding their experiences can provide invaluable insights that are not captured by operational data. Satisfaction scores help gauge the effectiveness of service improvements and impact long-term brand loyalty.

Overall Key Trends and Insights:
- The busiest routes are not always the most profitable, highlighting the need for a balance between demand management and revenue optimization. For example, some routes, like LAX-SFO, have high traffic but lower profitability per flight, indicating potential issues such as pricing strategies or cost inefficiencies.
- While JFK-LAX is the most profitable route, DCA-LGA stands out for its efficiency in revenue generation.
- There appears to be a positive correlation between profitability and on-time performance, suggesting that efficient operations can lead to both satisfied customers and higher profits.
- The average occupancy rates for some routes do not always align with their profitability, indicating that maximizing the number of passengers isn't the sole driver of revenue.
- The visualization of delay costs reveals significant variances across routes, with some high-profit routes incurring substantial delay-related expenses. This implies that while certain routes are profitable, there's room for improving operational efficiency and reducing additional costs associated with delays.
- LAX-SFO and ATL-LGA, despite having lower revenue to cost ratios, still maintain profitable operations. It may be beneficial to investigate why these routes have lower ratios and explore strategies to improve them.

Recommended Routes:
1. John F. Kennedy International Airport (JFK) to Los Angeles International Airport (LAX): This route not only leads in profitability but also excels in punctuality. The revenue to cost ratio is advantageous, indicating efficient management and high market demand.
2. Ronald Reagan Washington National Airport (DCA) to O'Hare International Airport (ORD): Demonstrates robust financial returns and operational effectiveness. The high revenue-to-cost ratio suggests the route is well-received in the market, with consistent demand.
3. Ronald Reagan Washington National Airport (DCA) to LaGuardia Airport (LGA): Notable for its remarkable revenue efficiency, this route also maintains high profitability and consistent occupancy, reflecting a strong position in the market.
4. Los Angeles International Airport (LAX) to San Francisco International Airport (SFO): Although this is one of the highest traffic routes, there is room for improvement in operational efficiency, particularly in managing delays, which could further increase its profitability.
5. Hartsfield–Jackson Atlanta International Airport (ATL) to LaGuardia Airport (LGA): This route provides reliable profitability with a strong record of on-time performance, indicative of a well-balanced approach to revenue generation and cost management.

Recommendations:
- Focus on enhancing and promoting the JFK-LAX and DCA-ORD due to its substantial contribution to total profits. Explore opportunities to optimize pricing strategies and flight schedules to further increase its profitability.
- Prioritize operational improvements on DCA-LGA, which already demonstrates high revenue efficiency. Consider increasing the frequency of flights or upselling additional services to maximize revenue on this route.
- Implement strict operational controls and contingency planning to improve the on-time performance for all routes, especially those with lower on-time percentages. This will imporove the brand image of punctuality and can lead to increased customer loyalty.
- For routes like LAX-SFO and ATL-LGA with lower revenue-to-cost ratios, conduct a cost analysis to identify areas where expenses can be reduced without compromising service quality.
- Routes with consistently high occupancy rates, such as JFK-LAX and DCA-LGA, should be used as models for best practices in marketing and customer satisfaction efforts. Leverage the high demand to test price elasticity and improve ancillary revenues.
- Integrate customer satisfaction metrics into regular performance reviews to ensure service standards meet or exceed expectations. This will be key to maintaining a competitive edge in a market where consumers have multiple choices.

Conclusion:
In conclusion, our comprehensive analysis of 1Q2019 data for the airline's prospective entry into the U.S. domestic market has revealed key routes that promise both high profitability and alignment with the brand's commitment to punctuality. The recommendations are based on a considerations of profitability, punctuality, operational efficiency, market demand, and financial performance, ensuring a strategic investment in the airline's expansion. The continuous tracking of KPIs such as profit per flight, on-time performance, occupancy rates, and passenger satisfaction will provide ongoing insights to refine operations and enhance customer experience.  

Next Steps for Better Decision Making:
- Expanding the dataset for higher precision analysis, for example expanding the dataset beyond one year and quarter.
- The Key Performance Indicators (KPIs) that bring the most value to the company should be tracked for better performance.
- Incorporating external data such as seasonal travel trends, competitive analysis, and economic factors to refine pricing strategies and forecast demand more accurately.
- Deploying predictive analytics to forecast future demand, delays, and operational disruptions, allowing proactive adjustments to schedules and operations.
- Regularly gather and analyze passenger feedback, particularly concerning on-time performance and service quality, to continuously refine the flight experience and operational priorities.
- For the R codes and functions, incorporating error handling to make it more reusable.
- Incorporate filters for the Airline Route Recommendation tableau dashboard to increase user interactivity with the data. 
