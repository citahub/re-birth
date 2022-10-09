class Numeric
  def timestamp_to_time
    Time.at(self/1000).to_s(:db)
  end

  def to_6
    BigDecimal(self.to_s)/(10.0**6)
  end
end

