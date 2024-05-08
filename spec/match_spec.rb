# frozen_string_literal: true

require_relative '../match'

RSpec.describe Match do
  let(:match) { Match.new(1) }

  describe '#initialize' do
    it 'initializes with correct attributes' do
      expect(match.id).to eq(1)
      expect(match.players).to eq([])
      expect(match.kills).to eq({})
      expect(match.kills_by_means).to eq({})
    end
  end

  describe '#add_player' do
    it 'adds a player correctly' do
      match.add_player('Player 1')
      expect(match.players).to include('Player 1')
      expect(match.players.count).to eq(1)
    end

    it 'does not add a player if they already exist' do
      match.add_player('Player 1')
      match.add_player('Player 1')
      expect(match.players).to include('Player 1')
      expect(match.players.count).to eq(1)
    end

    it 'adds different players correctly' do
      match.add_means('Player 1')
      match.add_means('Player 2')
      expect(match.kills_by_means).to include('Player 1', 'Player 2')
      expect(match.kills_by_means.count).to eq(2)
    end

    it 'does not add a player if the player is <world>' do
      match.add_player('<world>')
      expect(match.players).not_to include('<world>')
    end
  end

  describe '#add_means' do
    it 'adds a means of killing correctly' do
      match.add_means('Shotgun')
      expect(match.kills_by_means).to include('Shotgun')
      expect(match.kills_by_means.count).to eq(1)
    end

    it 'does not add a means of killing if it already exists' do
      match.add_means('Shotgun')
      match.add_means('Shotgun')
      expect(match.kills_by_means).to include('Shotgun')
      expect(match.kills_by_means.count).to eq(1)
    end

    it 'adds different means of killing correctly' do
      match.add_means('Shotgun')
      match.add_means('Pistol')
      expect(match.kills_by_means).to include('Shotgun', 'Pistol')
      expect(match.kills_by_means.count).to eq(2)
    end
  end

  describe '#add_kill' do
    before(:each) do
      match.add_player('Player 1')
      match.add_player('Player 2')
    end

    it 'adds a kill correctly' do
      match.add_kill('Player 1', 'Player 2', 'Shotgun')
      expect(match.kills['Player 1']).to eq(1)
      expect(match.kills_by_means['Shotgun']).to eq(1)
    end

    it 'decreases a kill if killer is <world>' do
      match.add_kill('<world>', 'Player 2', 'Shotgun')
      expect(match.kills['Player 2']).to eq(-1)
    end
  end

  describe '#report' do
    it 'returns the correct report' do
      match.add_player('Player 1')
      match.add_player('Player 2')
      match.add_kill('Player 1', 'Player 2', 'Shotgun')
      expect(match.report).to eq({
                                   "game_1": {
                                     "total_kills": 1,
                                     "players": ['Player 1', 'Player 2'],
                                     "kills": { 'Player 1' => 1, 'Player 2' => 0},
                                     "kills_by_means": { 'Shotgun' => 1 }
                                   }
                                 })
    end
  end
end
