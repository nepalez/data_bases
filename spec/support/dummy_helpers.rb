require "pathname"

module DummyHelpers
  def clear_dummy_db
    check_dummy_db_files.each { |f| `rm #{f}` }
  end

  def check_dummy_db_files
    Dir[File.expand_path("spec/dummy/db/*.sqlite3")]
  end

  def check_dummy_db_names
    check_dummy_db_files.map do |f|
      name = Pathname.new(f)
      name.basename(name.extname).to_s
    end
  end
end
