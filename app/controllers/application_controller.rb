class ApplicationController < ActionController::API
  def forwardable?(rumor)
    return false unless rumor
    rumor.length > 20
  end
end
