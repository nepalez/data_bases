RSpec.describe "rake db:{custom}:create", type: :rake do
  before  { clear_dummy_db }
  after   { clear_dummy_db }
  subject { Rake::Task["db:personal_data:create"].invoke }

  it "builds custom databases for the current env" do
    subject
    expect(check_dummy_db_names).to match_array %w(personal_test)
  end
end
