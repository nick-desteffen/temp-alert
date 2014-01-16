class TempAlert
  require 'forecast_io'
  require 'typhoeus'

  def initialize(config)
    @config = config
    @lat    = config.lat
    @lng    = config.lng

    ForecastIO.api_key = config.forecast_io
  end

  def check
    @forecast = ForecastIO.forecast(@lat, @lng)
    alert if very_cold?
  end

  def self.check(config)
    self.new(config).check
  end

private

  def alert
    messages = ["Warning, low temperature tonight, (#{coldest_temp}F)", summary]
    if @config.alert_mode == 'text_message'
      headers = {"content-type" => "application/json"}
      messages.each do |message|
        body = {
          contacts: [@config.sendhub.recipient_id],
          text: message
        }
        response = Typhoeus.post("https://api.sendhub.com/v1/messages/?username=#{@config.sendhub.username}\&api_key=#{@config.sendhub.api_key}", body: body.to_json, headers: headers)
      end
    else
      puts messages.inspect
    end
  end

  def very_cold?
    coldest_temp <= @config.alert_threshold
  end

  def coldest_temp
    @coldest_temp ||= @forecast.hourly.data[0..(@config.outlook_range - 1)].map(&:apparentTemperature).sort.first
  end

  def summary
    @summary ||= @forecast.hourly.summary
  end

end
