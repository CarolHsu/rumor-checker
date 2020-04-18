class User < Applicationrecord
  PLATFORMS = {
    line: 'line',
    telegram: 'telegram'
  }

  scope :from_line, -> { where(platform: PLATFORMS[:line]) }
end
