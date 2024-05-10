# Load necessary libraries
library(dplyr)

# Sample data (you can replace this with your own dataset)
data <- data.frame(
  ID = c(1, 2, 3, 4, 5),
  Name = c("John", "Alice", "Bob", "Emma", "David"),
  Age = c(25, 30, 40, 35, 28),
  Gender = c("M", "F", "M", "F", "M"),
  Score = c(85, 90, 75, 80, 88)
)

# Print the original data
cat("Original Data:\n")
print(data)

# Use dplyr to perform data processing
processed_data <- data %>%
  mutate(Age_Group = ifelse(Age < 30, "Young", "Old")) %>%
  filter(Gender == "M") %>%
  arrange(desc(Score)) %>%
  select(ID, Name, Age_Group, Score)

# Print the processed data
cat("\nProcessed Data:\n")
print(processed_data)
