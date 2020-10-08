class Story < ApplicationRecord
  has_many :logs

  def time_added?(value)
  	difference = (value - self.total_time)
  	difference.positive? && difference >= 900
  end
end
