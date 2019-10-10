class Api::Entrance::LianQuan::BaseController < ApplicationController
  before_action :check_token

  def api_error(status: 400, message: '错误')
    render json: {status: status, message: message, data: {}}
  end

  def api_success(message: '', data: {})
    render json: {status: 0, message: message, data: data}
  end

  def check_token
    @app_code = 'lianquan<=>gsh2019' # 81589b0ecce3c5a3b58ddb5105b8b056ccf3a1ad
    @app_token = Digest::SHA2.hexdigest('lianquan<=>gsh2019tahiti') # 7563edc7cc87d1a8dd6e7741dce90d889e74d6b2bd089e6e61835b1845a5b174
    if params[:timestamp].to_time < Time.now - 5.minute
      api_error(message: '请求已过期') and return
    end
    unless Digest::SHA2.hexdigest("app_code=#{@app_code}&app_token=#{@app_token}&timestamp=#{params[:timestamp]}") == params[:signature]
      api_error(message: '验证失败') and return
    end
  end

  def generate_token(interface: 'v1/system/currenttime')
    @guid = ''
    @timestamp = Time.now.to_i
    return @guid, @timestamp, Digest::SHA2.hexdigest("guid=#{@guid}&interface=#{interface}&timeStamp=#{@timestamp}")
  end


end
