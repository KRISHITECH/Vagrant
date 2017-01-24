#!/bin/bash

cd /farmbot-web-app

rake db:create:all db:migrate db:seed

RAILS_ENV=test rake db:create db:migrate && rspec spec

RAILS_ENV=development rake keys:generate

MQTT_HOST=localhost rails s


