require 'rails_helper'

RSpec.describe "Api::V1::Pairs", type: :request do
  describe '项目介绍' do
    let(:pair) { create(:project) }
    it '结对项目介绍' do
      get api_v1_pair_path(pair)
      api_v1_expect_success
      expect_json({ data: {name: '结对'} })
    end
  end
end
