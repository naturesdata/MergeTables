The purpose of sort-col-names.r is to use the mapping produced in the
KnownValues directory to produce an ordered list. The list consists of all
the column names for which a known value corresponding to an RID was found.
The column names act as the names of the list whereas the values of the list
are frequencies. These frequencies are the number of RIDs that have a known
value for that column name. The list is then sorted by these frequencies in
descending order such that the column name with the most known values is first
and the column with the least known values is last. The ordered list is saved
in sorted-col-names.rds.
