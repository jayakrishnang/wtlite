class HomeController < ApplicationController
  def index
    @logs = Log.where('log_date > ? AND log_date < ?', DateTime.now.beginning_of_month, DateTime.now.end_of_month)
  end

  def sync
  	TimeLoad.new(DateTime.now, true).load_time
  end
end
