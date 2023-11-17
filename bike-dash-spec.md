# Chicago Bike Dashboard Functional Specification

A dashboard to allow cyclists in Chicago to view and report problems and difficulties such as cars in bike lanes, damaged bike racks, etc.

## Pain Point

Cyclists in Chicago regularly have to deal with obstructions that can make biking in the City unsafe, and it can be difficult to report and track the problem.

## User Stories

As a cyclist, I want to be able to:

- Register my bike and report it stolen, so that I can hopefully recover it later
- Sync reported information with BikeIndex.org's API and 
- Report and track cars in bike lanes, so that I can observe areas I should avoid that frequently have this issue
- Report other issues I think cyclists near me should be aware of, such as "sucker poles", damages bike lanes, etc
- View issues on a map, so that I can better plan my route

As an city planner, I want to be able to:

- Easily retrieve data so that I can make effective planning decisions
- View hotspots of bike accidents, so that I can consider changes to traffic flow
- View issues that have high reports of theft, so that I can consider more secure bike parking and increased police presence

As an app administrator, I want to be able to:

- Review submitted reports, so that I can ensure accuracy and mitigate trolling and false submissions
- Batch reports to send through the Open311API , so that I can ensure the city has the needed information

## Domain Model

### Users
- id
- email
- password
- first_name
- last_name
- address
- bike_index_id *api reference*
- user_type
- lat
- lng

### Bikes
- id
- owner_id *fk*
- bike_index_id *api reference*

### Reports
- id
- reporter_id *fk*
- category
- address
- lat
- lng
- body
- chicago_id *api reference*

### Cars
- id
- style
- plate
- color
- model
- company_name

### ReportedBikes
- id
- report_id *fk*
- bike_id *fk*

### ReportedCars
- id
- report_id *fk*
- car_id *fk*

### Boards
- id
- name
- desc

### Posts
- id
- board_id *fk*
- author_id *fk*
- report_id *fk*
- subject
- text
- parent_id *self-fk* (if blank, post is main post.  If filled in, post is reply)

### ActiveStorage
- Users has_one_attached :avatar
- Bikes, Cars, and Posts each have_many_attached :images
