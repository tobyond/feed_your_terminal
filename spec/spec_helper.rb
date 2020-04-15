require "bundler/setup"
require "feed_your_terminal"
require "pry"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Db.db = SQLite3::Database.new("test_feeds.db")
  end

  config.after do
    File.delete("test_feeds.db")
  end
end
