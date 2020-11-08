main = function() {
    library('dplyr', warn.conflicts = FALSE, verbose = FALSE, quietly = TRUE)
    library('readr', warn.conflicts = FALSE, verbose = FALSE, quietly = TRUE)

    # Load in the raw data set and the column type map
    raw.data.set = readRDS('../RawDataSet/raw-data-set.rds')
    col.types = readRDS('../ColTypes/col-types.rds')

    # Convert both to data frames
    raw.data.set = data.frame(raw.data.set)
    col.types = data.frame(col.types)

    # Remove the unfit columns from the raw data set
    # Do this by selecting the names of fit columns
    # The column types table should only contain fit columns
    raw.data.set = select(raw.data.set, c('PTID', names(col.types)))

    # Remove the rows with NA patient IDs
    raw.data.set = raw.data.set %>% filter(!(PTID %>% is.na()))

    # Save them as CSV files
    write_csv(raw.data.set, 'raw-data-set.csv')
    write_csv(col.types, 'col-types.csv')
}

main()
