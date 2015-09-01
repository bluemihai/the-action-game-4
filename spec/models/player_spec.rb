require 'rails_helper'

RSpec.describe Player, type: :model do

  before(:each) { @player = FactoryGirl.create(:player) }

  subject { @player }

  it { should respond_to(:name) }

  it '#persist_sound_choice should change the sound' do
    expect(@player.sound_choice).to be nil
    @player.persist_sound_choice('foo')
    expect(@player.sound_choice).to eq('foo')
  end

  it "#name should return a string" do
    expect(@player.name).to match 'Test Player'
  end

  it '#admin? should return true for admins' do
    @player.role = :admin
    expect(@player.admin?).to be true
  end

  it '#init should build 1 team with membership, 1 role and 2 projects' do
    player = Player.new

    expect(player.teams.count).to eq(0)
    expect(player.roles.count).to eq(0)
    expect(player.projects.count).to eq(0)

    player.save!
    results = player.init

    expect(player.teams.count).to eq(1)
    team = results[0]

    pp team
    pp team.persisted?
    pp results
    pp team.id
    expect(team.projects.count).to eq(2)
    expect(team.roles.count).to eq(5)
  end

end
