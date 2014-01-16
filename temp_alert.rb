require 'bundler'
Bundler.require(:default)
Config = Hashie::Mash.new(YAML.load_file("./config/settings.yml"))
ForecastIO.api_key = Config.forecast_io

class TempAlert

  def initialize(lat, lng)
    @lat = lat
    @lng = lng
  end

  def check
    @forecast = ForecastIO.forecast(@lat, @lng)
    alert if very_cold?
  end

  def alert
    messages = ["Warning, low temperature tonight, (#{coldest_temp}F)", summary]
    if Config.alert_mode == 'text_message'
      headers = {"content-type" => "application/json"}
      messages.each do |message|
        body = {
          contacts: [Config.sendhub.recipient_id],
          text: message
        }
        response = Typhoeus.post("https://api.sendhub.com/v1/messages/?username=#{Config.sendhub.username}\&api_key=#{Config.sendhub.api_key}", body: body.to_json, headers: headers)
      end
    else
      puts messages.inspect
    end
  end

  def very_cold?
    coldest_temp <= Config.alert_threshold
  end

  def coldest_temp
    @coldest_temp ||= @forecast.hourly.data[0..(Config.outlook_range - 1)].map(&:apparentTemperature).sort.first
  end

  def summary
    @summary ||= @forecast.hourly.summary
  end

  def self.check(lat, lng)
    self.new(lat, lng).check
  end

end
