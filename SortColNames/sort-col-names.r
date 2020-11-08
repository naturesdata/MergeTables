main <- function() {
    known.vals = readRDS('../KnownValues/known-vals.rds')
    n.rids = length(known.vals)
    progress = 1
    col.name.counts = list()

    # For each column name, count the number of RIDs that have a known value for them
    for (next.rid in names(known.vals)) {
        rid.known.vals = known.vals[[next.rid]]
        
        for (col.name in names(rid.known.vals)) {
            if (col.name %in% names(col.name.counts)) {
                count = col.name.counts[[col.name]]
                count = count + 1
            }
            else {
                count = 1
            }

            col.name.counts[[col.name]] = count
        }

        print(paste('PROGRESS:', progress, '/', n.rids))
        progress = progress + 1
    }
    
    # Sort the column names in descending order by the amount of RIDs that have a known value for them
    sorted.col.names = col.name.counts[order(unlist(col.name.counts), decreasing = TRUE)]

    saveRDS(sorted.col.names, 'sorted-col-names.rds')
}

if (!interactive() & sys.nframe() == 0L) {
    main()
}
