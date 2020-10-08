# frozen_string_literal: true

module FormatTime
  def format
    "#{(self.to_f / 3600).floor}:#{((self.to_f % 3600) / 60).floor}:#{(self.to_f % 60).floor}"
  end

  def summary
  	"#{(self.to_f / 3600).floor(1)}"
  end
end

class Integer
  include FormatTime
end

class Float
  include FormatTime
end

class BigDecimal
  include FormatTime
end
