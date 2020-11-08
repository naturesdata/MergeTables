Each directory has a specific task. The tasks are in order, for some are
prerequisites of others. The order of the tasks by their corresponding
directory is AddTables, Dates, KnownValues, SortedColNames, RawDataSet,
ColTypes, and Stats. AddTables does not necesarrily need to be performed before
Dates, but both Dates and AddTables must be performed before KnownValues.
KnownValues precedes SortedColNames and both KnownValues and SortedColNames
must be complete before RawDataSet. RawDataSet precedes ColTypes and Stats.
ColTypes and RawDataSet must be complete before ToCSV.

Each directory contains an R script with a name reflecting the task of the
directory followed by a .r extension. There are also text files with the same
name as the R script but they have a .out extension rather than a .r
extension. The .out files contain the output of their respective R script.
