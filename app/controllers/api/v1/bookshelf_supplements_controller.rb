class Api::V1::BookshelfSupplementsController < Api::V1::BaseController
  before_action :set_supplement, only: [:update, :edit]

  def create
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:class][:class_id][0])
    @supplement = @bookshelf.supplements.new
    @supplement.loss = params[:class][:loss]
    @supplement.supply = params[:class][:supply]
    if @supplement.save
      api_success(data: {result: true, supplement_id: @supplement.id}, message: '提交成功！')
    else
      api_success(data: {result: false}, message: '提交失败，请重试！')
    end
  end

  def edit
    api_success(data: {supplement: @supplement.summary_builder} )
  end

  def update
    @supplement.project_season_apply_bookshelf_id = params[:class][:class][0]
    @supplement.loss = params[:class][:loss]
    @supplement.supply = params[:class][:supply]
    if @supplement.save
      api_success(data: {result: true, supplement_id: @supplement.id}, message: '提交成功！')
    else
      api_success(data: {result: false}, message: '提交失败，请重试！')
    end
  end

  private
  def set_supplement
    @supplement = BookshelfSupplement.find(params[:id])
  end

end
