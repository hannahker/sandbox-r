# Load necessary libraries
library(dplyr)
library(logger)

log_info("Sample environment variables...")
log_info(paste0("Test: ", Sys.getenv("TEST")))
log_info(paste0("First run: ", Sys.getenv("FIRST_RUN")))

# Sample data (you can replace this with your own dataset)
data <- data.frame(
  ID = c(1, 2, 3, 4, 5),
  Name = c("John", "Alice", "Bob", "Emma", "David"),
  Age = c(25, 30, 40, 35, 28),
  Gender = c("M", "F", "M", "F", "M"),
  Score = c(85, 90, 75, 80, 88)
)

# Use dplyr to perform data processing
processed_data <- data %>%
  mutate(Age_Group = ifelse(Age < 30, "Young", "Old")) %>%
  filter(Gender == "M") %>%
  arrange(desc(Score)) %>%
  select(ID, Name, Age_Group, Score)

log_info("...Finished processing data")
