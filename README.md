## temp-alert

**temp-alert** uses [forecast.io](https://developer.forecast.io/) to check the temperature at a specified time.  If it drops below a certain threshod during a specified range a text message will be sent using [SendHub](https://www.sendhub.com) to a specified phone number.

#### Configuring
Everything is configured using the `settings.yml` file.  Copy the the example file and enter your API keys from Forecast.io and Sendhub.  

#### Deploying
Deployment is done using [Capistrano V3](http://capistranorb.com/)  
  
`bundle exec cap production deploy`