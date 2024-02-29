# Reshare BorrowDirect Structure[^date]

## General Comments

The following tables are pulled directly from the ReShare implementation:

* Patron Requests
* Directory Entries
* Patron Request Rota
* Symbols
* Status
* Patron Request Audit

The remaining tables are constructed locally to form simple summary tables to build reports from:

* Transactions
* Lending Turnaround
* Borrowing Turnaround


# Transactions
This table is designed to incrementally update.  It creates two subtables, borrower and lender, to join together to form a snapshot of every transaction between a borrower and every potential lender.

When extracting the "nice" name for each lender and borrower, a join between the Patron Request and the Directory Entry table is made.  In order to correctly find the institution, the directory parent must be NULL.  This indicates we are at the top level of the institution.  However, when new entries are added, entries may temporarily be incomplete.  As such, multiple entries can be flagged as the same institution.  This is a rare occurrence so a restriction on the de_name is added for the following:

* Business Library (Manhattanville)
* Library Collections and Services Facility

# Lending Turnarounds
For each lender, there is a row of the status, and pertinent times in the lending lifecycle.  After an item has shipped, the turnaround times are calculated in days.

It is possible that a lender will cancel or otherwise leave an item unfulfilled.  No turnarounds are calculated, but an entry is made in the table.

# Borrowing Turnarounds
For each requested item, there is a row of the status, and pertinent times in the borrowing lifecycle.  After an item has checked as arriving at the borrowing institution, the turnaround times are calculated in days.

[^date]: February 2023
