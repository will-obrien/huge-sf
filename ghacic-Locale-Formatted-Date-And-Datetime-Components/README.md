# Locale Aware Visualforce Components
Visualforce components for rendering a locale aware date or datetime value within a Visualforce page.

## What's Included

```text
src/
    +-- classes/
    ¦   +-- localeFormattedDate.cls
    ¦   +-- localeFormattedDateTest.cls
    ¦   +-- localeFormattedDatetime.cls
    ¦   +-- localeFormattedDatetimeTest.cls
    +-- components/
    ¦   +-- localeFormattedDate.component
    ¦   +-- localeFormattedDatetime.component
    +-- pages/
        +-- localeFormattedSample.page
```

### Classes

- **localeFormattedDate**: controller for localeFormattedDate
- **localeFormattedDateTest**: unit tests for localeFormattedDate.cls
- **localeFormattedDatetime**: controller for localeFormattedDatetime
- **localeFormattedDatetimeTest**: unit tests for localeFormattedDatetime.cls

### Visualforce Components

- **localeFormattedDate**: Properly renders Date value based upon the running Uer's locale
- **localeFormattedDatetime**: Properly renders Datetime value based upon the running Uer's locale

### Visualforce Pages
- **localeFormattedSample**: Sample page for illustrating how to use the code

## Setup

### Deploy to Salesforce

[Deploy this code directly using "Deploy to Salesforce"](https://githubsfdeploy.herokuapp.com?owner=ghacic&repo=Locale-Formatted-Date-And-Datetime-Components)

### Manually Configure in Salesforce

1. Navigate to **Setup** > **Develop** > **Apex Classes**.
2. Click the **New** button on that page.
3. Copy and paste the code for localeFormattedDate.cls.
4. Click the **Save** button.

Repeat above steps for remaining three (3) classes.

1. Navigate to **Setup** > **Develop** > **Components**.
2. Click the **New** button on that page.
3. Copy and paste the code for localeFormattedDate.component.

Repeat above steps for remaining Visualforce component.

## How to Use

The "localeFormattedSample" Visualforce page is included to show you how to use the components.

```HTML
<c:localeFormattedDate dateProvided="{!Today()}"></c:localeFormattedDate>
<c:localeFormattedDatetime datetimeProvided="{!Now()}"></c:localeFormattedDatetime>
```
