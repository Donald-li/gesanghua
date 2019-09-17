class Api::Entrance::LingXi::BaseController < ApplicationController
  before_action :check_token
  skip_before_action :verify_authenticity_token

  def check_token
    @token = Digest::SHA1.hexdigest('lingxi-gsh') # 81589b0ecce3c5a3b58ddb5105b8b056ccf3a1ad
    unless @token == '81589b0ecce3c5a3b58ddb5105b8b056ccf3a1ad'
      api_error(message: '验证失败')
    end
  end
end
