# TravelExpenses for Salesforce.com #

<a href="https://githubsfdeploy.herokuapp.com?owner=Up2Go&repo=travelexpenses">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

<a href="https://codeclimate.com/github/Up2Go/travelexpenses"><img src="https://codeclimate.com/github/Up2Go/travelexpenses/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/Up2Go/travelexpenses"><img src="https://codeclimate.com/github/Up2Go/travelexpenses/badges/issue_count.svg" /></a>

[Installation/Download](#installationdownload) | [Screenshots](#screenshots) | [Know Issues/Todos](#known-issuestodos) | [Third Party Code](#third-party-code) | [Licence](#visualforce-tablegrid-license)

TravelExpenses is a free, open-source Salesforce.com application, designed to simplify the reimbursement process of business travels. 
There are two kinds of users, Travelers and Expense Managers.
The application is divided into two roles, Traveler and Expense Manager.
As an Traveler, you can easily state and sum up the expenses you had on your business trip via desktop or mobile device, making it easier for your expense manager to overview the costs. If you stated all your expenses you can submit the travel for reimbursement and start an (approval process) to hand it over to your expense manager. 
As an Expense Manager you can view and edit all data provided by the Traveler and check them for correctness. You are then able to reject or approve reimbursement requests, depending if the requirements of your organization are met.
On top of that TravelExpenses calculates the so-called 'Per Diems', a daily rate german business travelers receive to cover their catering costs. This calculation is based on the [german tax law for travel costs](http://www.bundesfinanzministerium.de/Content/DE/Monatsberichte/2014/03/Inhalte/Kapitel-3-Analysen/3-4-reform-steuerliches-reisekostenrecht.html)
and thereby adapted to travelers who fall under german taxation.



TravelExpenses ist eine kostenlose "open-source" Salesforce.com Anwendung welche den Rückerstattungsprozess für Reiseausgaben auf Geschäftsreisen vereinfacht. Damit kann jeder Geschäftsreisende nun leicht etwaige Ausgaben während einer Reise auflisten und zusammenrechen lassen, und damit der Reiseabrechnungsabteilung seiner Firma viel Arbeit und Zeit ersparen. Um dem Anwender die Eingabe und die Bearbeitung seiner Angaben zu erleichtern ist TravelExpenses sowohl mit Desktop als auch via Smartphone zugänglich. Zusätzlich berechnet TravelExpenses die sogenannten "Verpflegungspauschalen". Diese Tagessätze die jedem Reisenden während einer Geschäftsreise zustehen, werden anhand des deutschen [steuerlichen Reisekostenrechts](http://www.bundesfinanzministerium.de/Content/DE/Monatsberichte/2014/03/Inhalte/Kapitel-3-Analysen/3-4-reform-steuerliches-reisekostenrecht.html) errechnet. Dies minimiert die vom Reisenden einzugebenden Daten und befreit dessen Firma von der eigenen Berechnung der Tagessätze. Dadurch ist die Anwendung vor allem für Reisende gedacht die unter das deutsche Steuerrecht fallen.

 
## Features: ##
- Native Salesforce.com Look & Feel
- Native Salesforce1 Look & Feel
- Standalone mobile & desktop travel expense report app
- Installable on every Salesforce.com Org
- Automated calculation of Per Diems (Verpflegungspauschalen)
- PDF generation
- Complete integration of Salesforce Chatter
- Adapted to the german tax law


## Screenshots ##

<img src="https://github.com/Up2Go/travelexpenses/blob/master/resources/Salesforce1%20-%20Publisher%20Action%20-%20New%20Flight%20-%20Airfare.png" width="200">

<img src="https://github.com/Up2Go/travelexpenses/blob/master/resources/Salesforce1%20-%20Publisher%20Action%20-%20New%20Flight%20-%20Datetimepicker.png" width="200">

<img src="https://github.com/Up2Go/travelexpenses/blob/master/resources/Salesforce1%20-%20Publisher%20Action%20-%20New%20Travel.png" width="200">

## Known Issues/Todos ##

- tbd


## Third-party Code ##

- [Google Place Autocomplete](https://developers.google.com/places/documentation/autocomplete), returns place information based on text search terms and can be used to provide autocomplete functionality for text-based geographic searches.

- [jQuery](http://jquery.com), a fast, small, and feature-rich JavaScript library.

- [Bootstrap](http://getbootstrap.com/), the most popular HTML, CSS, and JS framework for developing responsive, mobile first projects on the web.

- [Bootstrap Switch](http://www.bootstrap-switch.org/), turns checkboxes and radio buttons in toggle switches.

- [Bootstrap datetimepicker](https://github.com/Eonasdan/bootstrap-datetimepicker), a nice datetimepicker widget.

- [Visualstrap](http://blogforce9dev-developer-edition.ap1.force.com/ProjectDetail?id=a0290000009MI61), a visualforce implementation of Bootstrap. VisualStrap is a set of components that work inside your visualforce page without affecting the standard layouts.



## TravelExpenses License ##

Copyright (C) 2013 UP2GO International LLC, David Renz, Robert Méndez

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
