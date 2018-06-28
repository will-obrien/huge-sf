# Visualforce Spreadsheets in JavaScript

This project is a proof of concept using HandsOnTable, SheetJS, and a bit of jQuery.
XLS, XLSX, or CSV files can be dropped onto the drop target in the VisualForce page. The
dropped file is then parsed, validated against a Salesforce controller's Remote Action,
and then displayed in a spreadsheet control provided by HandsOnTable.

There is a lot of custom validation in JavaScript to validate the data on load as well 
as when certain cells are edited. Rows containing errors are highlighted in a light red
with error cells in a slightly darker red. New rows (those missing an ID field) are
highlighted in blue. Updated records are displayed with a green background.

As records are edited, they are validated and the colors are adjusted based on valid 
values. Counts of new, updated, and error records are tallied and displayed in a separate
DIV.

There is also a button on the page that allows you to
upsert the records into Salesforce. If existing ID's are present, the records are updated.
If not, they are assumed to be new records and are inserted.

The Q promise library is also used to aggregate promises for validation and updates.

### Dependencies
---------

* [jQuery](http://www.jquery.com)
* [HandsOnTable](http://handsontable.com/)
* [SheetJS](http://github.com/SheetJS)
* [Q Promise Library](http://github.com/kriskowal/q)
* [Spin.js](http://fgnass.github.io/spin.js)




