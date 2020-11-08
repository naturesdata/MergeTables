library('ADNIMERGE')
library('dplyr')

# Used to select columns that don't have all NA values
not_all_na_in_col <- function(df) any(!is.na(df))

main <- function() {
    # The minimum number of columns a table can have
    MIN_N_COLS <- 2

    added_tables <- list()
    not_added <- c()
    table_names <- ls('package:ADNIMERGE')
    tbl_idx <- 1
    progress <- 1
    n_tables <- length(table_names)

    while (progress <= n_tables) {
        # Get the next table
        table_name <- table_names[progress]
        table <- get(table_name)
       
        print(paste('Table Name:', table_name))
        
        # Capitalize all the column names
        table <- rename_all(table, toupper)

        n_cols_before <- ncol(table)

        # Remove columns with all NA values
        table <- table %>% select_if(not_all_na_in_col)

        # Remove columns with only one unique value
        for (col_name in names(table)) {
            col <- select(table, !!sym(col_name))
            
            if (nrow(unique(col)) == 1) {
                table <- select(table, -!!sym(col_name))
                print(paste('REMOVING COLUMN WITH NAME:', col_name, 'FOR ONLY HAVING 1 UNIQUE VALUE'))
            }
        }
        
        n_cols_after <- ncol(table)

        if (n_cols_after < n_cols_before) {
            n_cols_removed <- n_cols_before - n_cols_after
            print(paste('NUMBER OF COLUMNS REMOVED:', n_cols_removed))
            print(paste('NUMBER OF COLUMNS LEFT:', n_cols_after))
        }

        can_add <- FALSE

        if (n_cols_after < MIN_N_COLS) {
            # Do not add tables with too few columns
            print(paste('THE NUMBER OF COLUMNS IN THE TABLE IS TO SMALL TO BE ADDED BECAUSE IT DOES NOT HAVE AT LEAST', MIN_N_COLS, 'COLUMNS'))
        }
        else if (!('RID' %in% names(table))) {
            # Do not add tables that are missing an RID column
            print('THE TABLE DOES NOT HAVE AN RID COLUMN AND COULD NOT BE ADDED')
        }
        else {
            can_add <- TRUE
        }

        if (can_add) {
            if (!('USERDATE' %in% names(table))) {
                print(paste('NO USER DATE:', table_name))
            }

            added_tables[[tbl_idx]] <- table
            tbl_idx <- tbl_idx + 1
        }
        else {
            not_added <- append(not_added, table_name)
        }
        
        print(paste('Progress:', progress, '/', n_tables))
        progress <- progress + 1
    }

    saveRDS(added_tables, 'added-tables.rds')
    saveRDS(not_added, 'not-added.rds')
}

main()
