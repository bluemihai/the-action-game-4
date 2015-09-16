require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) { @player = FactoryGirl.create(:player) }

  it '#initialize_for(player) should add projects and link them' do
    expect(Project.count).to eq(0)
    expect(@player.projects.count).to eq(0)
    team = FactoryGirl.create(:team)

    Project.initialize_for(team, @player)

    expect(Project.count).to eq(2)
    expect(@player.projects.count).to eq(2)
  end
end
