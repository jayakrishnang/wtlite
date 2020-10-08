class Log < ApplicationRecord
  belongs_to :story

  def self.months
     Log.order(log_date: :desc).pluck(:log_date).map{ |d| d.strftime("%B") }.uniq
  end

  def self.total(from, to)
    Log.where('log_date >= ? AND log_date <= ?', from, to).sum(:time)
  end

  def self.today
    self.total(Date.today, Date.today)
  end

  def self.this_week
    self.total(Date.today.beginning_of_week, Date.today.end_of_week)
  end

  def self.this_month
    self.total(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  def self.last_month
    self.total(Date.today.beginning_of_month - 1.month, Date.today.end_of_month - 1.month)
  end
end
