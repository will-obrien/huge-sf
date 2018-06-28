# trNgGridWithVF
trNgGrid with visualforce page.

[Website](http://ratanpaul.github.io/trNgGridWithVF)

[Installation Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t900000002Zkp)

This is a visualforce component. This is angular trnggrid table.

Features
- Pagination.
- Sorting.
- Column filter.
- Search by Column.
- Global Search

```
<c:RN_GenericTable strQuery="SELECT Id, FirstName, LastName, Email, Phone, CreatedDate FROM Contact" size="5"/>
```

Attributes
strQuery = pass query.
size = enter integer value for display rows.

![trNgGrid](https://raw.githubusercontent.com/RatanPaul/imges/master/img/trNGGridWithVF.png)

