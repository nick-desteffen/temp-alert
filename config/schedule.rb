set :output, "/var/log/cron.log"

## 10:30pm UTC
every :day, at: "4:30am" do
  rake "temp_alert"
end
