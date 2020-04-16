module AktionsHelper
  def name_is_flowing(action, default='flowing')
    "#{action.player.first_name} #{is_flowing(action, default)}"
  end

  def gravatar_is_flowing(action, default='flowing')
    "<img src=#{action.player.gravatar}> is #{action&.verb&.name&.downcase}".html_safe
  end

  private

  def is_flowing(action, default)
    return "is #{default}" unless action&.verb&.name

    "is #{action&.verb&.name&.downcase}"
  end

end
