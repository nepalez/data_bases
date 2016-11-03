# For every single database define a collection of rake tasks
require "data_bases/tasks"

namespace :db do
  DataBases.keys.each do |key|
    db_custom_namespace = namespace key do
      task :load_config do
        DataBases::Tasks.load_config(key)
      end

      namespace :create do
        task all: :load_config do
          DataBases::Tasks.create_all
        end
      end

      task create: :load_config do
        DataBases::Tasks.create_current
      end

      namespace :drop do
        task all: %w(load_config check_protected_environments) do
          DataBases::Tasks.drop_all
        end

        task _unsafe: :load_config do
          DataBases::Tasks.drop_current
        end
      end

      task drop: %w(check_protected_environments drop:_unsafe)

      namespace :purge do
        task all: %w(check_protected_environments load_config) do
          DataBases::Tasks.purge_all
        end
      end

      task purge: %w(check_protected_environments load_config) do
        DataBases::Tasks.purge_current
      end

      task migrate: %w(environment load_config) do
        DataBases::Tasks.migrate(key)
      end

      task reset: %w(drop setup)

      task version: %w(environment load_config) do
        puts "Current version: #{DataBases::Tasks.current_version}"
      end

      namespace :migrate do
        task reset: %w(drop create migrate)

        task redo: %w(environment load_config) do
          if ENV["VERSION"]
            db_custom_namespace["migrate:down"].invoke
            db_custom_namespace["migrate:up"].invoke
          else
            db_custom_namespace["rollback"].invoke
            db_custom_namespace["migrate"].invoke
          end
        end

        task up: %w(environment load_config) do
          version = ENV.fetch("VERSION") { fail "VERSION is required" }
          DataBases::Tasks.migrate_to(key, :up, version)
        end

        task down: %w(environment load_config) do
          version = ENV.fetch("VERSION") { fail "VERSION is required" }
          DataBases::Tasks.migrate_to(key, :down, version)
        end
      end

      task rollback: %w(environment load_config) do
        step = ENV.fetch("STEP", 1)
        DatabaseTasks.migrate_by(key, :rollback, step)
      end

      task forward: %w(environment load_config) do
        step = ENV.fetch("STEP", 1)
        DatabaseTasks.migrate_by(key, :forward, step)
      end

      task abort_if_pending_migrations: %w(environment load_config) do
        list = DataBases::Tasks.pending_migrations(key)
        size = list.size

        if size > 0
          item = "migration".pluralize size
          puts "Database '#{key}' has #{size} pending #{item}:"
          list.each { |m| puts "  #{m.version.format("%4d")} #{m.name}" }
          abort "Run `rake db:#{key}:migrate` or `rake db:migrate`, " \
                "then try again"
        end
      end

      task setup: %w(load_schema seed)

      task seed: :abort_if_pending_migrations do
        DataBases::Tasks.load_seed(key)
      end

      namespace :fixtures do
        task load: %w(environment load_config) do
          names = ENV["FIXTURES"].split(",")
          DataBases::Tasks.load_fixtures(key, *names)
        end
      end

      task dump: %w(environment load_config) do |task|
        DataBases::Tasks.dump(key, ENV["SCHEMA"])
        task.reenable
      end

      task load_schema: :load_config do
        DataBases::Tasks.load_schema(key, ENV["SCHEMA"])
      end

      namespace :test do
        task purge: %w(environment check_protected_environments load_config) do
          DataBases::Tasks.purge_current key, "test"
        end

        task load: :purge do
          DataBases::Tasks.load_schema key, ENV["SCHEMA"], "test"
        end

        task prepare: %w(environment load)
      end
    end
  end
end
