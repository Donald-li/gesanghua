require 'rails_helper'

RSpec.describe "Api::V1::Team", type: :request do

  let!(:user) { create(:user) }
  let!(:team) { create(:team, creater: user) }
  let!(:team_user) { create(:user, team: team) }

  describe '捐助团队' do
    it '获取用户的捐助团队' do
      get api_v1_teams_path(id: team_user.id)
      api_v1_expect_success
      expect(json_body[:data][:has_team]).to eq 'true'
      expect(json_body[:data][:team][:name]).to eq team.name
    end
  end

end
