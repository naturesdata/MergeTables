The purpose of add-tables.r is to create a list of all the tables to be
combined into a single tabular data set. This list is saved in
added-tables.rds.

This was done using the tables already loaded into the ADNIMERGE package. The
instructions for the installation of this package are found at
https://groups.google.com/forum/#!forum/adni-data

The "ADNIMERGE_0.0.1.tar.gz" file, as described by the documentation at the
url above, was obtained from the Study_Info directory downloaded from http://adni.loni.usc.edu

The main benefit of this step is that tables in the ADNIMERGE package are
conveniently placed together in a list. They are not in a list by default but
rather exist separately as individual objects in the ADNIMERGE package.
Additionally, the tables are preprocessed. All the headers are capatalized for
consistensy. Columns with all NA values or columns with all the same value are
removed. After columns were removed, if not enough were left, those tables
were not added to the list. Additionally, tables without an RID column are
removed. The names of the tables that couldn't be added for any of the above
listed reasons were recorded in not-added.rds.
