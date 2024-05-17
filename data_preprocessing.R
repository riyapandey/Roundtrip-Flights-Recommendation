# Function to read CSV files, treating strings as text and converting 'NA' strings to R's NA type
read_data <- function(file_path) {
  read.csv(file_path, stringsAsFactors = FALSE, na.strings = "NA")
}


# Identify and extract unique non-alphanumeric parts from numeric fields for data cleanup
extract_unique_non_alphanumeric_parts <- function(data, column_name) {
  non_numeric_parts <- gsub("[0-9]", "", data[[column_name]])
  unique_non_numeric_parts <- unique(non_numeric_parts)
  return(unique_non_numeric_parts)
}


# Convert specified columns to numeric types, cleaning non-numeric characters for accurate calculations
convert_numeric <- function(data, columns) {
  for (column in columns) {
    data[[column]] <- as.numeric(gsub("[^0-9\\.]", "", data[[column]]))
  }
  return(data)
}


# Parse date columns using specified formats to ensure uniform date data across the dataset
parse_dates <- function(data, date_columns, format_orders) {
  for (column in date_columns) {
    data[[column]] <- lubridate::parse_date_time(data[[column]], orders = format_orders)
  }
  return(data)
}


# Convert year information into a standard date format
convert_year_to_date <- function(year_column, date_format = "%Y-%m-%d") {
  as.Date(paste(year_column, "-01-01", sep=""), date_format)
}


# Convert specified data column to character format for easier text manipulation
convert_to_character <- function(data_column) {
  as.character(data_column)
}


# Split coordinates into longitude and latitude for geographical analysis
coordinates_conversion <- function(data, coord_column) {
  coords <- strsplit(data[[coord_column]], ",")
  data$LONGITUDE <- as.numeric(sapply(coords, function(x) trimws(x[1])))
  data$LATITUDE <- as.numeric(sapply(coords, function(x) trimws(x[2])))
  return(data[, !(names(data) %in% coord_column)])
}


# Replace NaN values with NA for consistent missing value handling
handle_na_nan <- function(data, columns) {
  for (column in columns) {
    data[[column]] <- ifelse(is.nan(data[[column]]), NA, data[[column]])
  }
  return(data)
}


# Ensure negative values in specified columns are converted to positive, if applicable
to_positive <- function(data, columns) {
  for (column in columns) {
    data[[column]] <- ifelse(!is.na(data[[column]]) & data[[column]] < 0, abs(data[[column]]), data[[column]])
  }
  return(data)
}


# Function to check for NA and empty strings across all columns, summarizing their counts and percentages
check_na_and_empty_strings <- function(data) {
  # Prepare a report dataframe to collect information
  results <- data.frame(
    column_name = names(data),
    na_count = numeric(ncol(data)),
    na_percent = numeric(ncol(data)),
    empty_string_count = numeric(ncol(data)),
    empty_string_percent = numeric(ncol(data)),
    stringsAsFactors = FALSE
  )
  # Iterate over each column in the data
  for (i in seq_along(data)) {
    column <- data[[i]]
    column_name <- names(data)[i]
    
    # Check for NA values
    results$na_count[i] <- sum(is.na(column))
    results$na_percent[i] <- mean(is.na(column)) * 100
    
    # If the column is character, check for empty strings and 'NA' strings
    if (is.character(column)) {
      trimmed_column <- trimws(column)  # Trim white spaces
      # Count empty strings and 'NA' (only if 'NA' is not valid data)
      results$empty_string_count[i] <- sum(trimmed_column == "" | trimmed_column == "NA")
      results$empty_string_percent[i] <- mean(trimmed_column == "" | trimmed_column == "NA") * 100
    }
  }
  # Order results by the count of NA values in descending order
  results <- results[order(-results$na_count), ]
  return(results)
}


# Function to impute missing values based on group medians or overall column medians if necessary
impute_missing_values <- function(data, columns, groups) {
  data %>%
    group_by(across(all_of(groups))) %>%
    mutate(across(all_of(columns), ~ ifelse(is.na(.), median(., na.rm = TRUE), .))) %>%
    ungroup() %>%
    mutate(across(all_of(columns), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))
}


# Function to calculate NA proportions in specific columns and decide on imputation or removal based on a threshold
na_proportions <- function(data, column, threshold = 0.05) {
  na_proportion <- sum(is.na(data[[column]])) / nrow(data)
  if (na_proportion < threshold) {
    data %>% filter(!is.na(.data[[column]]))
  } else {
    impute_missing_values(data, column, c("ORIGIN", "DESTINATION"))
  }
}


# Function to impute missing values in column2 based on correlation with column1
impute_based_on_correlation <- function(flights, column1, column2) {
  # Calculate the correlation between the two columns, ignoring missing observations
  correlation <- cor(flights[[column1]], flights[[column2]], use = "complete.obs")
  
  if (correlation > 0.7) {
    # If the correlation is strong, impute missing values in column2 based on column1
    flights <- flights %>%
      mutate("{column2}" := ifelse(is.na(.data[[column2]]),
                                   .data[[column1]] * median(.data[[column2]] / .data[[column1]], na.rm = TRUE),
                                   .data[[column2]]))
  } else {
    # If the correlation is weak, impute missing values in column2 based on the median per group
    flights <- flights %>%
      group_by(ORIGIN, DESTINATION) %>%
      mutate("{column2}" := ifelse(is.na(.data[[column2]]),
                                   median(.data[[column2]], na.rm = TRUE),
                                   .data[[column2]])) %>%
      ungroup()
  }
  return(flights)
}



# Function to impute missing values in one column based on the correlation with another column
impute_correlated <- function(data, x_col, y_col) {
  correlation <- cor(data[[x_col]], data[[y_col]], use = "complete.obs")
  if (correlation > 0.7) {
    data <- data %>%
      mutate({{y_col}} := ifelse(is.na({{y_col}}),
                                 {{x_col}} * median({{y_col}} / {{x_col}}, na.rm = TRUE),
                                 {{y_col}}))
  } else {
    data <- data %>%
      group_by(ORIGIN, DESTINATION) %>%
      mutate({{y_col}} := ifelse(is.na({{y_col}}),
                                 median({{y_col}}, na.rm = TRUE),
                                 {{y_col}})) %>%
      ungroup()
  }
  return(data)
}


# Function to remove all NA values from a specified column, ensuring clean data for analysis
filter_out_nas <- function(data, column) {
  data %>%
    filter(!is.na(.data[[column]]))
}


# Function to handle null or empty string values in character columns, ensuring data quality and consistency
character_columns_nas <- function(data, cols) {
  cols <- intersect(cols, names(data))
  data %>% 
    mutate(across(all_of(cols), ~na_if(.x, ""))) %>%  
    drop_na(all_of(cols))  
}


# Function to remove duplicate records in the dataset, enhancing the accuracy and reliability of analyses
remove_duplicates <- function(data, columns = NULL) {
  if (is.null(columns)) {
    distinct(data)
  } else {
    distinct(data, across(all_of(columns)))
  }
}


# Function to calculate skewness for specific columns, providing insights into data distribution asymmetry
calculate_skewness <- function(data, columns) {
  results <- sapply(columns, function(column) {
    # Extract the relevant column
    x <- data[[column]]
    
    # Calculate mean, median, and standard deviation
    mean_x <- mean(x, na.rm = TRUE)
    median_x <- median(x, na.rm = TRUE)
    sd_x <- sd(x, na.rm = TRUE)
    
    # Calculate skewness
    skewness <- 3 * (mean_x - median_x) / sd_x
    return(skewness)
  })
  return(results)
}


# Function to identify and summarize outliers in specific columns, facilitating robust statistical analyses
calculate_outliers <- function(data, columns) {
  # Ensure the data is a dataframe and the specified columns exist
  if (!is.data.frame(data)) {
    stop("Input must be a dataframe.")
  }
  if (!all(columns %in% names(data))) {
    stop("One or more specified columns do not exist in the dataframe.")
  }
  
  # Filter for numeric columns
  numeric_columns <- intersect(columns, names(data[sapply(data, is.numeric)]))
  if (length(numeric_columns) == 0) {
    stop("No numeric columns found among the specified columns.")
  }
  
  # Calculate bounds
  bounds <- sapply(data[numeric_columns], function(x) {
    qnt <- quantile(x, probs = c(0.25, 0.75), na.rm = TRUE)
    iqr <- IQR(x, na.rm = TRUE)
    lower_bound <- qnt[1] - 1.5 * iqr
    upper_bound <- qnt[2] + 1.5 * iqr
    c(lower = lower_bound, upper = upper_bound)
  })
  
  # Format the results as a dataframe for better readability
  bounds_df <- as.data.frame(t(bounds), stringsAsFactors = FALSE)
  names(bounds_df) <- c("Lower Bound", "Upper Bound")
  return(bounds_df)
}


# Function to cap outliers based on specified percentiles, reducing the impact of extreme values on analyses
cap_outliers <- function(data, columns) {
  for (column_name in columns) {
    lower_bound <- quantile(data[[column_name]], 0.01, na.rm = TRUE)
    upper_bound <- quantile(data[[column_name]], 0.99, na.rm = TRUE)
    data[[column_name]] <- ifelse(data[[column_name]] < lower_bound, lower_bound,
                                  ifelse(data[[column_name]] > upper_bound, upper_bound, data[[column_name]]))
  }
  return(data)
}


