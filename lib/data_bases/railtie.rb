module DataBases
  RESERVED_KEYS = %w(
    environment
    create
    drop
    purge
    migrate
    _dump
    reset
    rollback
    forward
    charset
    collation
    version
    abort_if_pending_migrations
    setup
    fixtures
    schema
    cache
    structure
    test
    railties
  )

  class Railtie < Rails::Railtie
    # Gem-specific configuration
    config.data_bases = ActiveSupport::OrderedOptions.new

    # Key for the default database in the `db/database.yml`
    config.data_bases.default_key = "base"

    initializer "data_bases.handle_database_configuration",
                before: "active_record.initialize_database" do |app|

      settings = app.config.database_configuration

      # Checks whether db keys conflict with rake tasks and namespaces
      conflicts = RESERVED_KEYS & settings.keys
      fail <<-TEXT.gsub(/ +\|/, "") if conflicts.any?
        |These keys in your `config/database.yml` are in conflict with names of rake tasks:
        |#{conflicts}.
        |You should choose other keys for your databases.
      TEXT

      # Checks whether default settings exist
      default_settings = settings[config.data_bases.default_key]
      fail <<-TEXT.gsub(/ +\|/, "") unless default_settings
        |Default database configuration has not been defined yet.
        |You should either add settings to the `config/database.yml` under the key :#{config.data_bases.default_key},
        |or assign another value to `config.data_bases.default_key` in `config/application.rb`.
      TEXT

      # Preserves content of `db/database.yml` using original AR method
      config.data_bases.settings = settings

      # Instead of loading config from `db/database.yml`,
      # method `database_configuration` will take
      # it from `config.additional_databases.current_settings`.
      app.config.define_singleton_method(:database_configuration) do
        Rails.application.config.data_bases.current_settings
      end

      # Sets `config.additional_databases.current_settings` to default
      # (by key from `config.additional_databases.default_key`)
      DataBases.send(:reset).apply_default
    end

    # Redefines AR database rake tasks, and defines new tasks for custom
    # databases (like `db:custom_base:create` etc.)
    rake_tasks do
      load "lib/tasks/db_custom.rake"
      load "lib/tasks/db.rake"
    end
  end
end
