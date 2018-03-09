class Api::V1::BookshelvesController < Api::V1::BaseController
  before_action :set_bookshelf

  def define_name
    @bookshelf.title = params[:define_name]
    @bookshelf.save
    api_success(data: true, message: '冠名成功！')
  end

  private
  def set_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
  end

end
