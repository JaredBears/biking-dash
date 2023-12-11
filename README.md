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
