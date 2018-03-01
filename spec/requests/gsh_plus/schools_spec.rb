require 'rails_helper'

RSpec.describe "Api::V1::GshPlus::School", type: :request do

  let!(:login_user) { create(:user) }

  describe '格桑花+引导页' do
    it '学校申请' do
      post api_v1_gsh_plus_schools_path,
           params: {
               school: {name: '北京一中', location: [110000, 110100, 110101], address: '人民路', postcode: '276000', describe: '规划局进口量将回归快乐',
                        contactName: '林则徐', contactPhone: '17888889999', contactTelephone: '05328652888', contactIdCard: '110229190001010913'},
               itemList: [{id: 0, tit:'学生人数', num: 330}, {id: 1, tit:'教师人数', num: 120}, {id: 2, tit:'后勤人数', num: 30}]
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data]).to eq true
    end
  end

end
