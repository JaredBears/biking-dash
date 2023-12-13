# README

This is a React on Rails Web Application.

* Ruby version: 3.2.2
* Rails version: 7.1.2
* React version: 18.2.0

## Use
This site is hosted at http://chicagobikedashboard.com

This site collects reports from public records and crowdsourcing in order to improve the cyclist experience in Chicago

## Installation

* Install HomeBrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
* Install Ruby `brew install ruby`
* Install React `yarn add react react-dom react-router-dom`
* Install Backend Dependancies: `bundle install`
* Install Frontend Dependancies: `yarn`
* Create Database: `rails db:create db:migrate`
* Import Starting Data: `rake db_reports:import_data`

## Setup and Useful Info

* While using this app locally in a dev environment, images are saved locally.  If you would like to change this, configure the `config/environments/development.rb` file and change the line `config.active_storage.service = :local` to point to your desired service.  (set up services in `config/storage.yaml`) 

* Delete the `credentials.yml.enc`` file and run `bin/rails credentials:edit` or `EDITOR="code --wait" bin/rails credentials:edit`  (Note to DPI Team Members: Reach out to me through the usual form of contact and I'll send you my master.key file so you can use the same credentials)

* You will need to sign up for Cloudinary (production only) and Google Maps (dev and production), as well as set up a Postgres database (production only)

* Add the following information to your `credentials.yml.enc` file:

```ruby
cloudinary:
  cloud_name: [your cloudinary cloud name]
  api_key: [your api key]
  api_secret: [your api secret]

google_maps_key: [your google maps api key]

db_url: [your db url, including login info]
```

## Unrestricted API Endpoints:
* `api/v1/reports/index` - GET - returns the 20 most recent reports in json format
* `api/v1/show/:id` - GET - returns the specified report in json format
