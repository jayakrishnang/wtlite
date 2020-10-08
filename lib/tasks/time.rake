require 'csv'

namespace :time do
  desc "To seed the users and their permissions"
  task :track => :environment do
    TimeLoad.new(DateTime.now, true).load_time
  end
end
