The purpose of known-values.r is create a mapping of RID to a list of known
values for that RID. The RIDs are a union of all the RIDs of all the tables
that were added by the script of the AddTables directory. The KnownValues
script also utilized the table produced by the Dates script.

This mapping is created by going through each table, and going through each
column of each table, and going through each RID in each table. For each RID,
the rows of the table corresponding to that RID are selected. From that
resulting table, the current column is selected. Then the value of the latest
USERDATE is selected. If the table does not have a USERDATE column, then the
dates table is merged in by joining by RID, PHASE, and VISCODE. If that
doesn't result in any non-NA dates, or if the table doesn't have a PHASE and
VISCODE column to merge by, a value is arbitrarily selected.
