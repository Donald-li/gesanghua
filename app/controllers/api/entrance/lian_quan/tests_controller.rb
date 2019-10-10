class Api::Entrance::LianQuan::TestsController < Api::Entrance::LianQuan::BaseController

  def show
    api_success(message: '请求成功', data: Time.now.to_i)
  end

end
