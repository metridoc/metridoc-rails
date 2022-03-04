# Tracking and Turnaround Updates[^date]

## General Comments

The process used to discover the starting status for each type of loan was to log on to the ILLiad server and query the Tracking table searching for the first instance of a transaction_number.  The following is an example SQL command on how to get the initial state of each transaction:

```
SELECT a.ChangedTo, COUNT(a.ChangedTo) AS total
FROM Tracking a
INNER JOIN (
  SELECT TransactionNumber, MIN(DateTime) AS DateTime
  FROM Tracking
  GROUP BY TransactionNumber
  ) b
ON a.TransactionNumber = b.TransactionNumber
AND a.DateTime = b.DateTime
INNER JOIN Transactions c
ON a.TransactionNumber = c.TransactionNumber
WHERE c.RequestType = 'Article'
AND c.ProcessType IN ('Borrowing')
GROUP BY a.ChangedTo
ORDER BY total DESC
```

Request Conditionalized means that the item is available and ready, but missing information from the requesting institution.  This could mean that the requesting institution either has some outstanding billing issues, the item requested is missing information such as a volume number, or the lending institution has a similar item but not the exact item requested such as a different edition of the same work.  For the purposes of turnaround times, using Request Conditionalized means that the lending institution is prepared to send an item.

Delivered to Web can occur more than once if there are issues with uploading a document.  As such, the Metridoc Tracking tables keep only the last Delivered to Web status.

Sometimes a request can be cancelled then reactivated, as such Cancelled by ILL Staff should only be considered the final state of a request if no other final states are seen after it.

## Borrowing
These records are created when Penn is borrowing material from another institution. Borrowing records contain more information in order to track the turnaround of the lending institution and the shipping time needed for the item to reach Penn.  As all lending institutions report in different ways, the History table is searched for a status that contains the word shipped in order to provide a best estimate of the item leaving the lending institution.

A Borrowing Request starts with one or more of the following statuses:
* 'Awaiting Copyright Clearance' - (Earliest)
* 'Awaiting Request Processing' - (Earliest)
Borrowing requests get viewed by a librarian before being sent to other institutions for fulfillment.  Sometimes this can happen multiple times if potential lending institutions are unable to fulfill the item and return the request back to Penn for fulfillment at another institution:
* 'Request Sent' - (Earliest)
A Borrowing Request is considered shipped when it reaches:
* 'Shipped' - (Earliest) This is pulled from the History table by searching for System updated statuses containing the word "shipped"
* 'Delivered to Web' - (Last)
A Borrowing Request is considered fulfilled when it reaches:
* 'Awaiting Post Receipt Processing' - (Earliest) The item is physically at Penn
* 'Delivered to Web' - (Last) The item is online available for download
A Borrowing Request is considered unfulfilled when it reaches:
* 'Cancelled by ILL Staff' (Last)

## Lending
These records are created when Penn is lending material to another institution.

A Lending Request starts with one or more of the following statuses:
* 'Awaiting Lending Request Processing' - (Earliest)
* 'Awaiting Local Request Processing' - (Earliest)
* 'Imported from OCLC' - (Earliest)
* 'Imported from DOCLINE' - (Earliest)
A Lending Request is considered fulfilled the first time it reaches one of the following:
* 'Request Finished' - A catchall status
* 'Request Conditionalized' - The item is found, but missing information from the requesting institution
* 'Item Shipped' - The item has physically left Penn
A Lending Request is considered unfulfilled when it reaches:
* 'Cancelled by ILL Staff' (Last)

# Document Delivery (Doc Del)
These records are created when Penn is transferring material in-house.  This encapsulates Penn specific services such as:
* Faculty Express
* Books by Mail

A Document Delivery Requests starts with one or more of the following statuses:
* 'Submitted by Customer'
* 'Request Added Through Client'
* 'Request Added through Web Platform'
A Document Delivery Request is fulfilled the first time it reaches one of the following:
* 'Delivered To Web'
* 'Item Found'
* 'Request Finished'
A Document Delivery Request is considered unfulfilled when it reaches:
* 'Cancelled by ILL Staff' (Last)

[^date]: Developed February 2022 by Karin Gilje with input from Sylvie Larsen, Tom Bruno and Lapis Cohen.
