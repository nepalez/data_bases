module DataBases
  # Container for custom db configuration
  class Config
    # @!attribute [r] key
    # @return [String] identifier for the current database
    attr_reader :key

    # @!attribute [r] config
    # @return [HashWithIndifferentAccess] database settings for all environments
    attr_reader :settings

    # @private
    def initialize(key, settings)
      @key      = key.to_s
      @settings = HashWithIndifferentAccess.new(settings)
    end

    # Absolute path to root db folder
    def db_root
      @db_root ||= Rails.root.join("db").tap { |dir| FileUtils.mkdir_p dir }
    end

    # Absolute path to root db subfolder for the current database
    # @return [String]
    def db_dir
      @db_dir ||= db_root.join(key).tap { |dir| FileUtils.mkdir_p(dir) }
    end

    # Absolute path to the default migration folder
    # @return [String]
    def db_migrate
      @db_migrate ||= db_dir.join("migrate").tap { |dir| FileUtils.mkdir_p dir }
    end

    # Absolute path to the seed file
    # @return [String]
    def db_seed
      @db_seed ||= db_dir.join("seed.rb")
    end

    # Loads custom seed from `/db/{key}/seed.rb` if it exists
    # @return [self]
    def load_seed
      load(db_seed) if db_seed.exist?
      self
    end

    # Settings for the current enviroment
    # @return [Hash]
    def current_settings
      settings[Rails.env]
    end

    # Applies current configuration
    # @return [self]
    def apply(new_settings = settings)
      Rails.application.config.data_bases.current_settings = new_settings
      ActiveRecord::Base.configurations = new_settings
      ActiveRecord::Base.establish_connection
    end
  end
end
