# Function to plot histograms for specified columns, visualizing the distribution of data values
plot_histograms <- function(data, column) {
  p <- ggplot(data, aes_string(x = column, fill = column)) +
    geom_histogram(bins = 30, color = "black", fill = "cornflowerblue", alpha = 0.6) +  # Added color and fill
    labs(title = paste("Histogram of", column), x = column) +
    theme_minimal() +
    scale_y_continuous(labels = scales::comma)
  return(p)
}


# Function to create box plots for specified columns, visually detecting outliers in the data
plot_boxplots <- function(data, column) {
  p <- ggplot(data, aes_string(x = column)) + 
    geom_boxplot(fill = "skyblue", color = "black", alpha = 0.7) +
    labs(title = paste("Boxplot of", column), x = column) +
    theme_minimal() +
    scale_y_continuous(labels = scales::comma)
  return(p)
}


# General function to create customizable bar plots for various data visualizations
plot_bar <- function(data, x_var, y_var, fill_color, title, x_label, y_label,
                     flip_coords = FALSE, use_dollar = FALSE, add_text = FALSE, 
                     text_var = "", text_position = "stack", text_color = "black") {
  
  if (!missing(y_var) && is.expression(substitute(y_var))) {
    data <- data %>% 
      mutate(!!rlang::sym(x_var) := !!rlang::sym(x_var),
             calc_y_var = !!rlang::eval(substitute(y_var)))
    y_var <- "calc_y_var"
  }
  
  # Create the initial bar plot
  p <- ggplot(data, aes_string(x = paste0("reorder(", x_var, ", -", y_var, ")"), y = y_var)) +
    geom_bar(stat = "identity", fill = fill_color) +
    labs(title = title, x = x_label, y = y_label) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Conditionally format the y-axis
  if (use_dollar) {
    p <- p + scale_y_continuous(labels = scales::dollar_format())
  } else {
    p <- p + scale_y_continuous(labels = scales::comma_format())
  }
  
  # Optionally add text labels to the bars
  if (add_text) {
    p <- p + geom_text(aes_string(label = text_var), position = position_stack(vjust = 0.5), color = text_color, size = 3.5)
  }
  
  # Optionally flip the coordinates
  if (flip_coords) {
    p <- p + coord_flip()
  }
  p
}


# Function to create scatter plots with labels, useful for detailed point data analysis
plot_scatter_label <- function(data, x_var, y_var, label_var, title, x_label, y_label, x_scale_dollar = FALSE) {
  p <- ggplot(data, aes(x = {{x_var}}, y = {{y_var}}, label = {{label_var}}, color = {{label_var}})) +
    geom_point(size = 5) +
    geom_text_repel(size = 3.5, box.padding = 0.35, point.padding = 0.5) +
    labs(title = title, x = x_label, y = y_label) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_brewer(palette = "Set2")
  
  if (x_scale_dollar) {
    p <- p + scale_x_continuous(labels = scales::dollar_format(suffix = "K", scale = 1e3))
  }
  p
}


# Function for creating segment plots, particularly useful for representing data with a start and endpoint
plot_segment <- function(data, x_var, y_var, title, x_label, y_label) {
  data <- data %>% 
    arrange(desc(!!rlang::sym(y_var))) %>%
    mutate(x = factor(!!rlang::sym(x_var), levels = unique(!!rlang::sym(x_var))))
  
  # Set up the segment plot
  ggplot(data, aes(x = x, y = !!rlang::sym(y_var))) +
    geom_segment(aes(xend = x, yend = 0), color = "grey") +
    geom_point(size = 5, color = "darkred") +
    labs(title = title, x = x_label, y = y_label) +
    theme_minimal() +
    scale_y_continuous(labels = scales::label_comma()) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))  
}


# Function for creating pie charts
plot_pie_chart <- function(data, value_col, label_col, title) {
  # Calculate percentages
  data$percentage <- (data[[value_col]] / sum(data[[value_col]])) * 100
  
  # Plot
  ggplot(data, aes(x = "", y = percentage, fill = !!sym(label_col))) +
    geom_bar(stat = "identity") +
    coord_polar("y", start = 0) +
    geom_text(aes(label = paste0(sprintf("%.2f", percentage), "%")), position = position_stack(vjust = 0.5)) +
    labs(title = title,
         fill = label_col,
         x = NULL,
         y = NULL) +
    theme_void() +
    theme(legend.position = "right")
}

