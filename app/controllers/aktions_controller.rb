class AktionsController < ApplicationController
  before_action :set_aktion, only: [:show, :edit, :update, :destroy]
  # before_action :authenticate_player!

  def start
  end

  def index
    @date = Date.strptime(params[:date]) if params[:date]
    @week = Date.strptime(params[:week]) if params[:week]
    @month = Date.strptime(params[:month]) if params[:month]
    @player = Player.find_by_id(params[:player_id]) || current_player

    if @date
      @actions = @player.actions_in_date_range(@date, @date)
    elsif @week
      @actions = @player.actions_in_date_range(@week.at_beginning_of_week, @week.at_end_of_week)
    elsif @month
      @actions = @player.actions_in_date_range(@month.at_beginning_of_month, @month.at_end_of_month)
    else
      @actions = @player.aktions
    end
  end

  def current
    @actions = Aktion.current
    output = @actions.map{ |a| {gravatar: a.player.gravatar, focus: a.focus}}
    render json: output
  end

  def test
    @actions = Aktion.last(30)
  end

  def show
  end

  def new
    @aktion = @current_player.aktions.new
    @aktion.team_id = params[:team_id]
    @aktion.intensity = 4
    slot = @current_player.current_action ? Aktion.current_timeslot + 30.minutes : Aktion.current_timeslot
    @aktion.timeslot = params[:timeslot] || slot
    @aktion.time_zone = @current_player.current_time_zone
    if params[:status] == 'planned'
      @aktion.planned = true
      @aktion.status = :planned
      @aktion.planned_date = Time.zone.now.to_date
    else
      @aktion.status = :committing
    end
    if params[:previous_aktion_id]
      @old = Aktion.find_by_id(params[:previous_aktion_id])
      @aktion.team = @old.team
      @aktion.verb = @old.verb
      @aktion.role = @old.role
      @aktion.project = @old.project
      @aktion.focus = @old.focus
      # @aktion.intensity = @old.intensity
    end
  end

  def edit
    @aktion.planned_date = Time.zone.now.to_date if @aktion.planned && !@aktion.planned_date
  end

  def create
    @aktion = Aktion.new(aktion_params)
    @aktion.status = :attempting
    @aktion.declared_focus = @aktion.focus
    respond_to do |format|
      if @aktion.save
        format.html { redirect_to aktion_form }
        format.json { render :show, status: :created, location: @aktion }
      else
        format.html { render :new }
        format.json { render json: @aktion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # If it's < 5 min into Action, allow player to change focus
    if [0, 1, 2, 3, 4, 30, 31, 32, 33, 34].include?(Time.now.min)
      @aktion.declared_focus = @aktion.focus
    end
    respond_to do |format|
      if @aktion.update(aktion_params)
        if params[:commit] == 'STOP NOW'
          @aktion.update_attributes(status: :stopped)
        elsif params[:commit] == 'SAVE'
          @aktion.update_attributes(status: :reviewed)
        end
        format.html { redirect_to aktion_form }
        format.json { render :show, status: :ok, location: @aktion }
      else
        format.html { render :edit }
        format.json { render json: @aktion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @aktion.destroy
    respond_to do |format|
      format.html { redirect_to aktions_url, notice: 'Aktion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_aktion
      @aktion = Aktion.find(params[:id])
    end

    def aktion_params
      params.require(:aktion).permit(:timeslot, :focus, :player_id, :verb_id, :project_id, :flow,
        :flow_notes, :value, :value_notes, :visible_to, :status, :intensity, :how_it_went, :music,
        :time_zone, :location_id, :role_id, :properties, :team_id, :water, :breaths, :pushups, :situps,
        :wallsits, :choice, :snack, :tidy, :stop, :restroom, :stretch, :games, :friends, :other,
        :change, :planned_date, :planned_sequence_number, :planned, :deflected, :jumpjacks, :chairdips,
        :distractions, :recovered, :started_at, :stopped_at, :declared_focus, :awesome_break, :tight_focus,
        :reading, :podcast)
    end

    def aktion_form
      edit_aktion_path(@aktion)
    end
end
