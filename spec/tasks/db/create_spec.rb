RSpec.describe "rake db:create", type: :rake do
  before  { clear_dummy_db }
  after   { clear_dummy_db }
  subject { Rake::Task["db:create"].invoke }

  it "builds all databases for the current env" do
    subject
    expect(check_dummy_db_names).to match_array %w(personal_test base_test)
  end
end
