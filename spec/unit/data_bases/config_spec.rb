RSpec.describe DataBases::Config do
  let(:config) { described_class.new :personal_data, settings }
  let(:settings) do
    {
      "test" => {
        "adapter"  => "sqlite3",
        "database" => "./db/personal_test.sqlite3"
      },
      "development" => {
        "adapter"  => "sqlite3",
        "database" => "./db/personal_dev.sqlite3"
      },
    }
  end

  describe ".new" do
    subject { config }

    its(:key)        { is_expected.to eq "personal_data" }
    its(:settings)   { is_expected.to eq settings }
  end

  describe ".db_root" do
    subject { config.db_root }

    it { is_expected.to be_a Pathname }
    its(:to_s) { is_expected.to eq File.expand_path("spec/dummy/db") }
  end

  describe ".db_dir" do
    subject { config.db_dir }

    it { is_expected.to be_a Pathname }
    its(:to_s) { is_expected.to eq File.expand_path("spec/dummy/db/personal_data") }
  end

  describe ".db_migrate" do
    subject { config.db_migrate }

    it { is_expected.to be_a Pathname }
    its(:to_s) { is_expected.to eq File.expand_path("spec/dummy/db/personal_data/migrate") }
  end

  describe ".db_seed" do
    subject { config.db_seed }

    it { is_expected.to be_a Pathname }
    its(:to_s) { is_expected.to eq File.expand_path("spec/dummy/db/personal_data/seed.rb") }
  end

  describe ".apply" do
    before { config.apply }

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
  end
end
