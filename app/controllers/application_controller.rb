class ApplicationController < ActionController::API
  def keywords
    # TODO: config/coronavirus.yml
    ['coronavirus']
  end

  def forwardable?(rumor)
    return false unless rumor
    rumor.length > 20
  end

  def group_chat?
    raise NotImplementedError
  end

  def get_current_user
    raise NotImplementedError
  end

  def about_coronavirus?
    raise NotImplementedError
  end
end
