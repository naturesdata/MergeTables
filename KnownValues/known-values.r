# Function that determines whether a column is a given class
is_class <- function(col, class_name) {
    clas <- sapply(col, class)
    query <- clas[length(clas)] == class_name
    return(query)
}

main <- function() {
    library('dplyr', warn.conflicts = FALSE, verbose = FALSE, quietly = TRUE)

    # Load all the available tables and the dates table
    dates <- readRDS('../Dates/dates.rds') %>% data.frame()
    tables <- readRDS('../AddTables/added-tables.rds')

    n_tables <- length(tables)

    if (file.exists('tbl-idx.rds')) {
        known_vals <- readRDS('known-vals.rds')
    }
    else {
        known_vals <- list()
    }

    if (file.exists('tbl-idx.rds')) {
        progress <- readRDS('tbl-idx.rds')
    }
    else {
        progress <- 1
    }

    if (progress == n_tables + 1) {
        # If an entire run of this script was previously completed, restart from the beginning
        known_vals <- list()
        progress <- 1
    }

    while (progress <= n_tables) {
        table <- tables[[progress]]

        # Convert the table back to a data frame since it was converted to a list when it was saved in the .rds file
        table <- data.frame(table)

        col_names <- names(table)

        has_user_date <- 'USERDATE' %in% col_names
        can_get_user_date <- 'PHASE' %in% col_names & 'VISCODE' %in% col_names

        # Get all the unique RIDs for this table
        rids <- table %>% select(RID) %>% unique() %>% unlist()

        for (rid in rids) {
            # Skip any rids that are NA
            if (is.na(rid)) {
                next
            }

            # Get the character array version of the RID so it can be used as a name for the RID to known values map
            rid_c <- as.character(rid)

            if (rid_c %in% names(known_vals)) {
                # Get the list of known values for this RID
                rid_vals <- known_vals[[rid_c]]
            }
            else {
                # Create a new empty list for this RID
                rid_vals <- list()
            }
            
            # Get the rows corresponding to the current rid
            rid_rows <- table %>% filter(RID == rid)

            for (col_name in col_names) {
                # Skip the RID column
                if (col_name == 'RID') {
                    next
                }

                # If the current RID already has a known value for the current variable (column name), continue to the next column
                if (col_name %in% names(rid_vals)) {
                    next
                }

                # Filter the rows where the current variable is NA (not known)
                no_na <- rid_rows %>% filter(!(!!sym(col_name) %>% is.na()))

                # If there are no known values of the current variable (column) for this RID, continue to the next column
                if (nrow(no_na) == 0) {
                    next
                }

                # If possible, get the value of the most recent date, else arbitrary pick the first value in the column
                if (!has_user_date) {
                    if (can_get_user_date) {
                        temp <- no_na
                        no_na <- no_na %>% inner_join(dates, by = c('RID', 'PHASE', 'VISCODE'))

                        if (nrow(no_na) != 0) {
                            no_na <- no_na %>% filter(USERDATE == max(USERDATE, na.rm = TRUE))

                            if (nrow(no_na) == 0) {
                                no_na <- temp
                            }
                        }
                        else {
                            no_na <- temp
                        }
                    }
                }

                val <- no_na[1, col_name]

                if (is_class(val, 'factor') | is_class(val, 'logical')) {
                    val = as.character(val)
                }

                rid_vals[col_name] <- val
            }

            # Update the list of known values for this RID in the RID to known values map
            known_vals[[rid_c]] <- rid_vals
        }

        print(paste('PROGRESS:', progress, '/', n_tables))
        progress <- progress + 1

        saveRDS(known_vals, 'known-vals.rds')
        saveRDS(progress, 'tbl-idx.rds')
    }
}

if (!interactive() & sys.nframe() == 0L) {
      main()
}
