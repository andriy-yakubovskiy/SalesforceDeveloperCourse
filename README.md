# Recruiting App
Custom objects: Position, Candidate, Job Application, Review.
Custom list-views, layouts, record type, components LWC, access and etc.

- Visualforce-page:
The page a list of ‘JobApplication’ with information about ‘Candidate’. (standardController)

- Visualforce-page:
The page a list of ‘Position’, with a filter by ‘Status’ field. Possibility to edit ‘Status’ in the list. (custom controller or extension)

- LWC:
The page a list of ‘Position’, with a filter by ‘Status’ field. Possibility to change ‘Status’ in the list. (component LWC)
Pagination between pages with ‘Positions’. Forward-backward and jump to a concrete page. (pagination is a separate component LWC)

- LWC:
Detail Page for ‘Position’ Record.
Output for 'Position' all of ‘Candidates’ applying for this Position. (component LWC)
Each of ‘Candidate’ is on a separate card.
Two types of settings: The first is the custom Settings button in the component itself. The second is in Custom Metadata Types.
All settings use FieldSet.
All additional information shows through a modal window (pop-up).
Pagination between 'Candidate' cards. (pagination is a separate component LWC)

- Lightning, override standard actions
Custom create-form in LWC for the object 'Candidate' (appear when you click on the "new" button on the ‘Candidate’ Tab). Through Aura.

- Apex trigger
-Trigger for ‘Position’, set the current date to the ‘Closed_date’ field if ‘Position’ Status has changed to "Closed".
-Trigger for ‘JobApplication’, closes ‘Position’ if its Status changes to "hired".

...
