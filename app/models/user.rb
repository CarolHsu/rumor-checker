class User < ApplicationRecord
  PLATFORMS = {
    line: 'line',
    telegram: 'telegram'
  }

  scope :from_line, -> { where(platform: PLATFORMS[:line]) }
  scope :from_telegram, -> { where(platform: PLATFORMS[:telegram]) }

  def from_line
    self.platform = PLATFORMS[:line]
  end

  def from_telegram
    self.platform = PLATFORMS[:telegram]
  end
end
