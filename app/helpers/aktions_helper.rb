module AktionsHelper
  def is_tagging(action, default='flowing')
    return "is #{default}" unless action&.verb&.name

    "#{action.player.first_name} is #{action&.verb&.name&.downcase}"
  end
end
