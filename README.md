# powerbi-fullscreen
Website to embed Power BI content in a webpage and render it fullscreen without UI elements. Optionally refreshes data sources with intervals.

This can be hosted on a an Azure Web App as well as a regular IIS site (on premise or on Azure VM).


## Prerequisites

1. Create Azure AD app from https://portal.azure.com (see [documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications)). Chose "Web app / API" as the application type. Set Required Permissions for Power BI and with permissions which will at least support whatever you are planning to do and set "Reply URL" to where you host the site.

2. Configure web.config with Client ID, Redirect URI and Key from the Azure AD app created above.


## Usage - Report

In order to display a report in an embedded page without chrome or UI elements:

```http://<website>/?WorkspaceID=<WorkspaceID>&ReportID=<ReportID>&ReportSection=<ReportSection>&RefreshIntervalMinutes=<RefreshIntervalAsMinutes>```
  
<website>: whatever hostname you use to host your website
<WorkspaceID>, <ReportID>, <ReportSection>: details of the report that you are showing, these IDs can be found by navigating to the report in Power BI and get the details out of the URL.
<RefreshIntervalAsMinutes>: if report should update automatically from dataset, define this in minutes. Can be omitted for no refresh.


## Usage - Dashboard

In order to display a dashboard in an embedded page without chrome or UI elements:

```http://<website>/?WorkspaceID=<WorkspaceID>&DashboardID=<DashboardID>&RefreshIntervalMinutes=<RefreshIntervalAsMinutes>```
  
<website>: whatever hostname you use to host your website
<WorkspaceID>, <DashboardID>: details of the dashboard that you are showing, these IDs can be found by navigating to the report in Power BI and get the details out of the URL.
<RefreshIntervalAsMinutes>: if dashboard should update automatically from dataset, define this in minutes. Can be omitted for no refresh.
