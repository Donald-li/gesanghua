require 'rails_helper'

RSpec.describe Baidu, type: :lib do

  it '测试签名' do
    token = Baidu.auth_str(url: 'https://bos.cn-n1.baidubce.com/example?text&text1=测试&text10=test', headers: {Auth: 'aaa'})
    # pp token
  end

  it '测试发短信' do
    res = Baidu.send_sms
    # pp res.body
  end
end
