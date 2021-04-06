# Function that determines whether a column is a given class
is.class = function(col, class_name) {
    clas = sapply(col, class)
    query = clas[length(clas)] == class_name
    return(query)
}

# Determines the type of a column
get.col.type = function(col, col.name) {
    nom.type = 'nominal'
    num.type = 'numeric'
    min.n.unique.vals = 10
    max.n.unique.vals = 20

    col.len = nrow(col)
    n.na.vals = sum(is.na(col))

    # Get the number of unique non NA values in the column
    n.unique.vals = filter(col, !is.na(!!sym(col.name))) %>% unique() %>% nrow()

    # If the column only has one unique value, it is not fit
    if (n.unique.vals == 1) {
        return(NA)
    }

    if (is.class(col, 'integer') | is.class(col, 'numeric')) {
        if (n.unique.vals <= min.n.unique.vals) {
            # The column has few enough unqiue values to be considered nominal
            return(nom.type)
        }
        else {
            # The column is likely numeric if it is an integer or float and has enough unique values
            return(num.type)
        }
   }
   else {
       if (n.unique.vals >= max.n.unique.vals) {
           return(NA)
       }
       else {
           # Column is nominal
           return(nom.type)
       }
   }
}

main = function() {
    library('dplyr', warn.conflicts = FALSE, verbose = FALSE, quietly = TRUE)

    raw.data.set = readRDS('../RawDataSet/raw-data-set.rds')
    raw.data.set = data.frame(raw.data.set)

    col.names = names(raw.data.set)
    n.cols = length(col.names)
    progress = 1
    col.types = list()

    # Go through each column and determine its type
    for (col.name in col.names) {
        # Skip the patient ID column
        if (col.name == 'PTID') {
            next
        }

        col = select(raw.data.set, all_of(col.name))

        # Map the column name to the column type
        col.type = get.col.type(col, col.name)

        if (!is.na(col.type)) {
            col.types[[col.name]] = col.type
        }
        else {
            # Don't include columns that are unfit
            print('COLUMN IS UNFIT')
        }

        print(paste('PROGRESS:', progress, '/', n.cols))
        progress = progress + 1
    }

    saveRDS(data.frame(col.types), 'col-types.rds')
}

if (!interactive() & sys.nframe() == 0L) {
        main()
}
