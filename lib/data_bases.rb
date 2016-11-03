require "rails"

# Container for additional databases settings/connections
# for the current environment
module DataBases
  require_relative "data_bases/config"
  require_relative "data_bases/railtie"

  class << self
    include  Enumerable
    delegate :each, :[], :keys, to: :@config

    # @!attribute [r] settings
    # @return [HashWithIndifferentAccess] settings from `config/database.yml`
    attr_reader :settings

    # @!attribute [r] default_key
    # @return [String] identifier for the default database
    attr_reader :default_key

    # Resets the container from the application's config
    # @return [self]
    def reset
      Rails.application.config.data_bases.tap do |config|
        @default_key = config.default_key
        @settings    = HashWithIndifferentAccess.new(config.settings)
      end

      @config = settings
        .each_with_object(HashWithIndifferentAccess.new) do |(key, val), hash|
          hash[key] = Config.new(key, val)
        end

      self
    end

    # Applies settings for database selected by key.
    # @return [self]
    def apply_default
      tap { |db| db[default_key].apply }
    end
  end
end
