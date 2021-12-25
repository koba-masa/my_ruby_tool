require 'bundler/setup'

class Base
  def initialize
    Bundler.require(*[:default, :development])
    Config.load_and_set_settings(File.expand_path('../../config/settings.yml', __FILE__))
  end
end
