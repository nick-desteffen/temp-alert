set :output, "/var/log/cron.log"

require 'hashie'
require 'yaml'
config = Hashie::Mash.new(YAML.load_file("./config/settings.yml"))

every :day, at: config.alert_time do
  rake "temp_alert"
end
