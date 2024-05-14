# Load necessary library
library(ggplot2)
library(logger)

# Generate random data
n <- 100  # Number of data points
data <- data.frame(
  x = 1:n,
  y = rnorm(n)
)

# Create the plot
plot <- ggplot(data, aes(x = x, y = y)) +
  geom_line() +
  labs(title = paste("Random Data Line Plot Generated:", Sys.time()))  # Include date and time in plot title

# Save the plot using ggsave
plot_filename <- paste("docs/random_data_plot", ".png", sep = "")  # Unique filename with timestamp
ggsave(plot_filename, plot, width = 8, height = 6, dpi = 100)  # Adjust width, height, and dpi as needed

log_info(paste0("Plot generated and saved to ", plot_filename))