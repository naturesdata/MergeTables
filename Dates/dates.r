library('dplyr')
library('readr')

# Read in the registry table
dates <- read_csv('REGISTRY.csv')

# Select the columns necessary to merge USERDATE into other tables
dates <- dates %>% select(RID, Phase, VISCODE, USERDATE)

# Arrange by RID for convenience
dates <- dates %>% arrange(RID)

# Make sure all the column names are capitalized
dates <- dates %>% rename_all(toupper)

# Save the dates table
saveRDS(dates, 'dates.rds')
