## temp-alert

**temp-alert** uses [forecast.io](https://developer.forecast.io/) to check the temperature at a specified time.  If it drops below a certain threshold during a specified time range a text message will be sent using [EzTexting](https://www.eztexting.com/) to a specified phone number.

#### Configuring
Everything is configured using the `settings.yml` file.  Copy the the example file and enter your API key from Forecast.io and credentials for EzTexting.  

#### Deploying
Deployment is done using [Capistrano V3](http://capistranorb.com/)  
  
`bundle exec cap production deploy`
