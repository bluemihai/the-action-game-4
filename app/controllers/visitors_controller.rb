class VisitorsController < ApplicationController
  def chat
  end

  def contact
  end

  def index
  end

  def help
  end

  def scores
  end

  def sounds
    sound = params[:sound_choice]
    session[:sound_choice] = sound
    current_player.persist_sound_choice(sound) if player_signed_in?
    redirect_to back_or_home
  end

  def welcome
    player = Player.find_by(email: params[:current_user])
    if player
      session[:player_id] = player.id
      redirect_to edit_player_path(player), :notice => "Signed in as #{player.name}!"
    end
  end
end
