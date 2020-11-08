# Function that determines whether a column is a given class
is_class <- function(col, class_name) {
    clas <- sapply(col, class)
    query <- clas[length(clas)] == class_name
    return(query)
}

main = function() {
    # Load the mapping of RIDs to their list of known values and the column names sorted by the number of RIDs that have a value for them
    known.vals = readRDS('../KnownValues/known-vals.rds')
    sorted.col.names = readRDS('../SortColNames/sorted-col-names.rds')
    
    # Just use the names of the columns and not their frequencies (number of RIDs that have a value for them)
    sorted.col.names = names(sorted.col.names)

    raw.data.set = list()
    n.cols = length(sorted.col.names)
    progress = 1

    # Add the patient ID column
    raw.data.set[['PTID']] = names(known.vals)

    # Construct the raw data set one column at a time
    for (col.name in sorted.col.names) {
        col = c()
        i = 1

        # Construct the column one RID at a time
        for (rid.known.vals in known.vals) {
            # If the current RID has a known value for the current column name, add it to the column
            if (col.name %in% names(rid.known.vals)) {
                val = rid.known.vals[[col.name]]
            }
            else {
                # If the RID does not have a known value for the current column name, add NA to the column
                val = NA
            }

            if (!is.na(val)) {
                # If the value is a factor or logical, store it as a string so it can be used as a nominal feature rather than an integer
                if (is_class(val, 'factor') | is_class(val, 'logical')) {
                    val = as.character(val)
                }
            }

            col[[i]] = val
            i = i + 1
        }
        
        raw.data.set[[col.name]] = col

        print(paste('PROGRESS:', progress, '/', n.cols))
        progress = progress + 1
    }

    saveRDS(data.frame(raw.data.set), 'raw-data-set.rds')
}

if (!interactive() & sys.nframe() == 0L) {
        main()
}
