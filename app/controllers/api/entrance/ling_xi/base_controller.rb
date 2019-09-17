class Api::Entrance::LingXi::BaseController < ApplicationController
  # before_action :check_token
  skip_before_action :verify_authenticity_token

  def api_error(status: 400, message: '错误')
    render json: {status: status, message: message, data: {}}
  end

  def api_success(message: '', data: {})
    render json: {status: 0, message: message, data: data}
  end

  def check_token
    @token = Digest::SHA1.hexdigest('lingxi-gsh') # 81589b0ecce3c5a3b58ddb5105b8b056ccf3a1ad
    unless @token == params[:token]
      api_error(message: '验证失败')
    end
  end
end
