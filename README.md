# Recruiting App
Custom objects: Position, Candidate, Job Application, Review.
Custom list-views, layouts, record type, components LWC, access and etc.

- Visualforce-page:
The page a list of ‘JobApplication’ with information about ‘Candidate’. (standardController)

- Visualforce-page:
The page a list of ‘Position’, with a filter by ‘Status’ field. Possibility to edit ‘Status’ in the list. (custom controller or extension)
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226054354-fb15d8c2-7a16-4003-838a-1a4952822261.png">
</p>

- LWC:
The page a list of ‘Position’, with a filter by ‘Status’ field. Possibility to change ‘Status’ in the list. (component LWC)
Pagination between pages with ‘Positions’. Forward-backward and jump to a concrete page. (pagination is a separate component LWC)
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226054895-dcd919a3-633e-4159-985c-4cad7e943995.png">
</p>

- LWC:
Detail Page for ‘Position’ Record.
Output for 'Position' all of ‘Candidates’ applying for this Position. (component LWC)
Each of ‘Candidate’ is on a separate card.
Two types of settings: The first is the custom Settings button in the component itself. The second is in Custom Metadata Types.
All settings use FieldSet.
All additional information shows through a modal window (pop-up).
Pagination between 'Candidate' cards. (pagination is a separate component LWC)
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226055232-df20d97b-b050-44e2-ad57-1d9ab3f17dad.png">
</p>
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226055942-77937193-3b4b-4764-b8c3-15ae63768af3.png">
</p>

- Lightning, override standard actions
Custom create-form in LWC for the object ‘Candidate’. Date of ‘Candidate’ and ‘JobApplication’ on one page. (appear when you click on the "new" button on the ‘Candidate’ Tab). Through Aura.
<p align="center">
  <img width=75% height=75% src="https://user-images.githubusercontent.com/95531033/226056071-748aa953-9cc8-4bc5-9434-0a01ad0ab183.png">
</p>

- Apex trigger
-Trigger for ‘Position’, set the current date to the ‘Closed_date’ field if ‘Position’ Status has changed to "Closed".
-Trigger for ‘JobApplication’, closes ‘Position’ if its Status changes to "hired".

...
