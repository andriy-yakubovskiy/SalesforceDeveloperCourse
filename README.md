# Recruiting App - Salesforce Developer Course #
This project is a Recruiting App designed as part of a Salesforce Developer training course. 
It demonstrates a variety of Salesforce development techniques including Access, Visualforce pages, Lightning Web Components (LWC), Aura components (as a wrapper), Apex code, Apex triggers, Custom objects, ListViews, Layouts, RecordType and etc.

## Overview ##
The application models a recruiting process with the following custom objects:<br>
**- Position<br>**
**- Candidate<br>**
**- Job Application<br>**
**- Review<br>**

## Features ##
- Custom Objects & Data Modeling<br>
**- Objects:** Position, Candidate, Job Application, and Review.<br>
**- Record Types & Layouts:** Customized to suit the recruiting workflow.<br>
**- ListViews:** Pre-configured to provide quick access to key records.<br>
- Visualforce Pages<br>
**- Job Application List:** Displays a list of Job Applications with associated Candidate information. (Uses standard controller)<br>
**- Position List:** Shows a list of Positions with a filter by the Status field. Allows inline editing of the Status field and is implemented with a custom controller / extension.<br>
<p align="center">
<img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226054354-fb15d8c2-7a16-4003-838a-1a4952822261.png">
</p>

- Lightning Web Components (LWC)<br>
**- Position Listing with Pagination:<br>**
-A component that displays a list of Positions, filtered by Status.<br>
-Supports inline status changes.<br>
-Incorporates pagination functionality with options to navigate forward, backward, or jump directly to a specific page.<br>
(Note: Pagination is implemented as a separate LWC component.)<br>
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226054895-dcd919a3-633e-4159-985c-4cad7e943995.png">
</p>

**- Position Detail Page:<br>**
-A detailed view for a single Position record, displaying all Candidates who have applied.<br>
-Each Candidate is presented on an individual card.<br>
-Features two methods for configuration: a custom Settings button within the component and settings defined in Custom Metadata Types using FieldSets.<br>
-Additional Candidate details are shown in a modal window with pagination between Candidate cards.<br>
(Pagination is also implemented as a separate LWC component.)<br>
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226055232-df20d97b-b050-44e2-ad57-1d9ab3f17dad.png">
</p>
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226055942-77937193-3b4b-4764-b8c3-15ae63768af3.png">
</p>

 - Lightning Overrides & Aura Integration<br>
**- Custom Create-Form for Candidate:<br>**
-Overrides the standard action to provide a custom creation form for the Candidate object.<br>
-Combines Candidate and Job Application data on a single page, accessible via the "New" button on the Candidate tab.<br>
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226056071-748aa953-9cc8-4bc5-9434-0a01ad0ab183.png">
</p>

 - Apex Triggers<br>
**- Position Trigger:<br>**
-Automatically sets the current date in the Closed_date field when a Position's Status changes to "Closed".<br>
**- Job Application Trigger:<br>**
-Automatically closes the corresponding Position when the Job Application’s status changes to "hired".<br>
<br>

----------
git clone https://github.com/andriy-yakubovskiy/SalesforceDeveloperCourse.git
