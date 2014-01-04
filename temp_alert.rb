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
    body = {
      contacts: [Config.sendhub.recipient_id],
      text: "Going to be cold"
    }
    headers =  {"content-type" => "application/json"}
    response = Typhoeus.post("https://api.sendhub.com/v1/messages/?username=#{Config.sendhub.username}\&api_key=#{Config.sendhub.api_key}", body: body.to_json, headers: headers)
  end

  def very_cold?
    @forecast.currently.apparentTemperature <= 20
  end

  def self.check(lat, lng)
    self.new(lat, lng).check
  end

end
