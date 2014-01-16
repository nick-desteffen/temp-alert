task default: 'temp_alert'

task :temp_alert do
  require 'hashie'
  require 'yaml'
  require_relative 'temp_alert'
  config = Hashie::Mash.new(YAML.load_file("./config/settings.yml"))

  TempAlert.check(config)
end
