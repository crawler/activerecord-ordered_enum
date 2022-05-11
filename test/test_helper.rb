# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "active_record/ordered_enum"
require "active_support"
require "active_record"

DATABASE_PATH = Pathname.new(__dir__).join("test.db")

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: DATABASE_PATH)

# Set up STDOUT or provide a filename like 'log.txt'
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

# To disable the ANSI color output:
ActiveSupport::LogSubscriber.colorize_logging = false

require "minitest/autorun"
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |rb| require(rb) }

Minitest.after_run { DATABASE_PATH.delete if DATABASE_PATH.exist? }
