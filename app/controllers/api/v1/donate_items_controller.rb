class Api::V1::DonateItemsController < Api::V1::BaseController

  def index
    donate_items = DonateItem.show.sorted
    api_success(data: donate_items.map{|i| i.summary_builder})
  end

end
