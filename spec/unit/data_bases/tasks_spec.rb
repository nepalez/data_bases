require "data_bases/tasks"

RSpec.describe DataBases::Tasks do
  describe ".load_config" do
    before { described_class.load_config(:personal_data) }

    it "reloads Rails.application.config.database_configuration" do
      expect(Rails.application.config.database_configuration).to eq \
        "test" => {
          "adapter" => "sqlite3",
          "database" => "./db/personal_test.sqlite3"
        },
        "development" => {
          "adapter" => "sqlite3",
          "database" => "./db/personal_dev.sqlite3"
        }
    end

    it "sets ActiveRecord::Base.configurations" do
      expect(ActiveRecord::Base.configurations).to eq \
        "test" => {
          "adapter" => "sqlite3",
          "database" => "./db/personal_test.sqlite3"
        },
        "development" => {
          "adapter" => "sqlite3",
          "database" => "./db/personal_dev.sqlite3"
        }
    end

    it "establishes ActiveRecord::Base.connection" do
      expect(ActiveRecord::Base.connection.instance_variable_get(:@config))
        .to eq adapter:  "sqlite3",
               database: File.expand_path("spec/dummy/db/personal_test.sqlite3")
    end

    it "reloads ActiveRecord::Tasks::DatabaseTasks.db_dir" do
      expect(ActiveRecord::Tasks::DatabaseTasks.db_dir)
        .to eq File.expand_path("spec/dummy/db/personal_data")
    end

    it "makes the config seed_loader" do
      seed_loader = ActiveRecord::Tasks::DatabaseTasks.seed_loader

      expect(seed_loader).to be_kind_of DataBases::Config
      expect(seed_loader.key).to eq "personal_data"
    end

    it "sets current config" do
      expect(ActiveRecord::Tasks::DatabaseTasks.current_config).to eq \
        "adapter"  => "sqlite3",
        "database" => "./db/personal_test.sqlite3"
    end

    context "with explicit env" do
      before { described_class.load_config(:personal_data, "development") }

      it "sets custom config" do
        expect(ActiveRecord::Tasks::DatabaseTasks.current_config).to eq \
          "adapter"  => "sqlite3",
          "database" => "./db/personal_dev.sqlite3"
      end
    end
  end

  describe ".fixtures_path" do
    subject { described_class.fixtures_path(:personal_data) }

    it "adds namespace to original path" do
      expect(subject)
        .to eq File.expand_path("spec/dummy/test/fixtures/personal_data")
    end
  end

  describe ".migrations_paths" do
    subject { described_class.migrations_paths(:personal_data) }

    it "adds namespace to original path" do
      expect(subject)
        .to eq [File.expand_path("spec/dummy/db/personal_data/migrate")]
    end
  end

  pending do
    describe ".migrate" do
    end

    describe ".migrate_to" do
    end

    describe ".migrate_by" do
    end

    describe ".pending_migrations" do
    end

    describe ".version" do
    end

    describe ".load_fixtures" do
    end

    describe ".load_schema" do
    end

    describe ".dump" do
    end

    describe ".dump_schema" do
    end

    describe ".dump_structure" do
    end
  end
end
