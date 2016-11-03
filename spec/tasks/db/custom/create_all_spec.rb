RSpec.describe "rake db:{custom}:create:all", type: :rake do
  before  { clear_dummy_db }
  after   { clear_dummy_db }
  subject { Rake::Task["db:personal_data:create:all"].invoke }

  it "builds custom databases for all environments" do
    subject
    expect(check_dummy_db_names).to match_array %w(personal_test personal_dev)
  end
end
