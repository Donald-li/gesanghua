class Api::V1::MainsController < Api::V1::BaseController

  def show

  end

  def banners
    @banners = Advert.visible.sorted
    api_success(data: @banners.map{|banner| banner.summary_builder})
  end

  def campaigns
    
  end
end
