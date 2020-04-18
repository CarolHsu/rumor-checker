class User < Applicationrecord
  PLATFORMS = {
    line: 'line',
    telegram: 'telegram'
  }

  scope :from_line, -> { where(platform: PLATFORMS[:line]) }

  def from_line
    self.platform = 'line'
  end
end
