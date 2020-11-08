REGISTRY.csv (the registry table) was obtained from the Enrollment directory downloaded from http://adni.loni.usc.edu

The purpose of dates.r is to create a new table, stored in dates.rds. The
dates table is the same as the REGISTRY table except that it only has the
RID, PHASE, VISCODE, and USERDATE columns.

Thus, this table acts as a mapping of RID, PHASE, and VISCODE to USERDATE. The purpose
of this is so tables that don't have a USERDATE column can be joined with
the dates table by RID, PHASE, and VISCODE. Thus those tables will have a
USERDATE column which can be used to pick the most recent value. The headers
in the dates table are capitalized because the headers in all the other tables
are capitalized.
