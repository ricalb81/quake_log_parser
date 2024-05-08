# frozen_string_literal: true

require_relative '../log_parser'

RSpec.describe LogParser do
  let(:log_parser) { LogParser.new }

  describe '#initialize' do
    it 'initializes with correct attributes' do
      expect(log_parser.instance_variable_get(:@matches)).to eq([])
    end
  end

  describe '#parse' do
    let(:file_name) { 'quake.log' }
    subject(:parse_log) do
      # mocking the file to avoid reading the actual file
      expect(File).to receive(:foreach).with(file_name)
                                       .and_yield('12:13 ------------------------------------------------------------')
                                       .and_yield('12:13 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\bot_minplayers\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0')
                                       .and_yield('12:14 ClientUserinfoChanged: 2 n\Player 1\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0')
                                       .and_yield('12:14 ClientUserinfoChanged: 3 n\Player 2\t\0\model\uriel/zael\hmodel\uriel/zael\g_redteam\\g_blueteam\\c1\5\c2\5\hc\100\w\0\l\0\tt\0\tl\0')
                                       .and_yield('12:21 ClientUserinfoChanged: 4 n\Player 3\t\0\model\sarge/default\hmodel\sarge/default\g_redteam\\g_blueteam\\c1\1\c2\5\hc\100\w\0\l\0\tt\0\tl\0')
                                       .and_yield('12:24 Kill: 3 4 6: Player 1 killed Player 2 by MOD_ROCKET')
                                       .and_yield('12:26 Kill: 3 2 7: Player 1 killed Player 3 by MOD_ROCKET_SPLASH')
                                       .and_yield('13:02 Kill: 1022 5 22: <world> killed Player 2 by MOD_TRIGGER_HURT')
                                       .and_yield('14:15 Kill: 2 5 10: Player 3 killed Player 2 by MOD_RAILGUN')
                                       .and_yield('14:38 Kill: 1022 5 22: <world> killed Player 3 by MOD_TRIGGER_HURT')
                                       .and_yield('15:13 ------------------------------------------------------------')

      log_parser.parse(file_name)
    end

    it 'parses the log file correctly' do
      expect(log_parser).to receive(:new_match).once
      expect(log_parser).to receive(:add_player_to_match).exactly(3).times
      expect(log_parser).to receive(:add_kill_to_match).exactly(5).times

      parse_log
    end
  end

  describe '#new_match' do
    it 'creates a new match correctly' do
      expect { log_parser.new_match }.to change { log_parser.matches.size }.by(1)
    end
  end

  describe '#add_player_to_match' do
    let(:match) { Match.new(1) }
    it 'adds a player to the match correctly' do
      line = 'ClientUserinfoChanged: 2 n\\Player 1\\t\\0'
      log_parser.add_player_to_match(match, line)
      expect(match.players).to include('Player 1')
    end
  end

  describe '#add_kill_to_match' do
    let(:match) { Match.new(1) }
    before(:each) do
      line = 'ClientUserinfoChanged: 2 n\\Player 1\\t\\0'
      log_parser.add_player_to_match(match, line)
    end

    it 'adds a kill to the match correctly' do
      line = 'Kill: 1022 2 22: Player 1 killed Player 1 by MOD_SHOTGUN'
      log_parser.add_kill_to_match(match, line)
      expect(match.kills['Player 1']).to eq(1)
      expect(match.kills_by_means['MOD_SHOTGUN']).to eq(1)
    end
  end

  describe '#report' do
    let(:file_name) { 'quake.log' }

    it 'returns the correct report' do
      # mocking the file to avoid reading the actual file
      expect(File).to receive(:foreach).with(file_name)
                                       .and_yield('12:13 ------------------------------------------------------------')
                                       .and_yield('12:13 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\bot_minplayers\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0')
                                       .and_yield('12:14 ClientUserinfoChanged: 2 n\Player 1\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0')
                                       .and_yield('12:14 ClientUserinfoChanged: 3 n\Player 2\t\0\model\uriel/zael\hmodel\uriel/zael\g_redteam\\g_blueteam\\c1\5\c2\5\hc\100\w\0\l\0\tt\0\tl\0')
                                       .and_yield('12:21 ClientUserinfoChanged: 4 n\Player 3\t\0\model\sarge/default\hmodel\sarge/default\g_redteam\\g_blueteam\\c1\1\c2\5\hc\100\w\0\l\0\tt\0\tl\0')
                                       .and_yield('12:24 Kill: 3 4 6: Player 1 killed Player 2 by MOD_ROCKET')
                                       .and_yield('12:26 Kill: 3 2 7: Player 1 killed Player 3 by MOD_ROCKET_SPLASH')
                                       .and_yield('13:02 Kill: 1022 5 22: <world> killed Player 2 by MOD_TRIGGER_HURT')
                                       .and_yield('14:15 Kill: 2 5 10: Player 3 killed Player 2 by MOD_RAILGUN')
                                       .and_yield('14:38 Kill: 1022 5 22: <world> killed Player 3 by MOD_TRIGGER_HURT')
                                       .and_yield('15:13 ------------------------------------------------------------')

      log_parser.parse(file_name)
      expect(log_parser.report).to eq([{
                                   "game_1": {
                                     "total_kills": 5,
                                     "players": ["Player 1", "Player 2", "Player 3"],
                                     "kills": { "Player 1"=>2, "Player 2"=>-1, "Player 3"=>0},
                                     "kills_by_means": { "MOD_ROCKET"=>1, "MOD_ROCKET_SPLASH"=>1, "MOD_TRIGGER_HURT"=>2, "MOD_RAILGUN"=>1 }
                                   }
                                 }])

    end
  end
end
