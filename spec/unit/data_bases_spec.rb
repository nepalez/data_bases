RSpec.describe DataBases do
  describe ".settings" do
    subject { described_class.settings }

    it { is_expected.to be_a HashWithIndifferentAccess }

    it "contains all settings" do
      expect(subject).to eq \
        "base" => {
          "test" => {
            "adapter" => "sqlite3",
            "database" => "./db/base_test.sqlite3"
          },
          "development" => {
            "adapter" => "sqlite3",
            "database" => "./db/base_dev.sqlite3"
          }
        },
        "personal_data" => {
          "test" => {
            "adapter" => "sqlite3",
            "database" => "./db/personal_test.sqlite3"
          },
          "development" => {
            "adapter" => "sqlite3",
            "database" => "./db/personal_dev.sqlite3"
          }
        }
    end
  end

  describe ".[]" do
    subject { described_class[:personal_data] }

    it { is_expected.to be_a DataBases::Config }
    its(:key) { is_expected.to eq "personal_data" }

    it "carries single db settings" do
      expect(subject.settings).to eq \
        "test" => {
          "adapter" => "sqlite3",
          "database" => "./db/personal_test.sqlite3"
        },
        "development" => {
          "adapter" => "sqlite3",
          "database" => "./db/personal_dev.sqlite3"
        }
    end
  end
end
