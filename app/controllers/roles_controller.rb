class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :set_team, except: [:show, :edit, :update, :destroy]

  def index
    @roles = params[:team_id] ? current_team.roles : current_player.roles
  end

  def show
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    @role = Role.new(role_params)
    if @role.short.nil? || @role.short == ''
      @role.short = @role.name
    end
    respond_to do |format|
      if @role.save
        format.html { redirect_to current_team, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to current_team, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def set_team
      @team = Team.find_by_id(params[:team_id]) || current_team
    end

    def role_params
      params.require(:role).permit(:name, :team_id, :url, :description, :parent_id, :short, :external_id)
    end
end
