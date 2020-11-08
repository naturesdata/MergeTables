This is the directory where the raw (unprocessed) data set is made. The
columns of the raw data set are in order by most known values (least NA).
This order is known by loading in the sorted column names. Only the names
are used, the frequencies only having been used to determine order. The known
values mapping is also loaded. For each column name, we go through each RID.
If the RID has a known value for the current column, it is added. Otherwise NA
is added to the column. Values of type factor and logical are converted to
character arrays to avoid the issue of R converting them to integers when
placed in the data set. We want those to be treated as nominal, not numeric.
The resulting data frame is saved in raw-data-set.rds.
