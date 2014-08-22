class TempAlert
  require 'forecast_io'
  require 'eztexting'

  def initialize(config)
    @config = config
    @lat    = config.lat
    @lng    = config.lng

    ForecastIO.api_key = config.forecast_io
    Eztexting.connect!(@config.eztexting.username, @config.eztexting.password)
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
    messages = ["Warning, low temperature tonight: (#{coldest_temp}F)", summary]
    if @config.alert_mode == 'text_message'
      messages.each do |message|
        Eztexting::Sms.single(phonenumber: @config.eztexting.recipient_number, message: message)
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
