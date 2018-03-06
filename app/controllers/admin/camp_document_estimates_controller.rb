class Admin::CampDocumentEstimatesController < Admin::CampDocumentBaseController
  before_action :set_camp_document_estimate, only: [:show, :edit, :update, :destroy]

  def index
    @search = CampDocumentEstimate.in_season(@current_camp).sorted.ransack(params[:q])
    scope = @search.result
    @camp_document_estimates = scope.page(params[:page])
  end

  def show
  end

  def new
    @camp_document_estimate = CampDocumentEstimate.new
  end

  def edit
  end

  def create
    @camp_document_estimate = CampDocumentEstimate.new(camp_document_estimate_params.merge(user: current_user, project_season: @current_camp))
    respond_to do |format|
      if @camp_document_estimate.save
        format.html { redirect_to admin_camp_document_estimates_url, notice: '新增成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @camp_document_estimate.update(camp_document_estimate_params)
        format.html { redirect_to admin_camp_document_estimates_url, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @camp_document_estimate.destroy
    respond_to do |format|
      format.html { redirect_to admin_camp_document_estimates_url, notice: '删除成功' }
    end
  end

  private
    def set_camp_document_estimate
      @camp_document_estimate = CampDocumentEstimate.find(params[:id])
    end

    def camp_document_estimate_params
      params.require(:camp_document_estimate).permit!
    end
end