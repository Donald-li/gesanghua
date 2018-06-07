class Admin::CampDocumentSummariesController < Admin::CampDocumentBaseController
  before_action :set_camp_document_summary, only: [:show, :edit, :update, :destroy]

  def index
    @search = CampDocumentSummary.in_apply(@current_apply).sorted.ransack(params[:q])
    scope = @search.result
    @camp_document_summaries = scope.page(params[:page])
  end

  def show
  end

  def new
    @camp_document_summary = CampDocumentSummary.new
  end

  def edit
  end

  def create
    @camp_document_summary = CampDocumentSummary.new(camp_document_summary_params.merge(user: current_user, apply: @current_apply, camp: @current_apply.camp))
    respond_to do |format|
      if @camp_document_summary.save
        @camp_document_summary.attach_report(params[:report_id])
        format.html { redirect_to referer_or(admin_camp_document_summaries_url), notice: '新增成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @camp_document_summary.update(camp_document_summary_params)
        @camp_document_summary.attach_report(params[:report_id])
        format.html { redirect_to referer_or(admin_camp_document_summaries_url), notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @camp_document_summary.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_camp_document_summaries_url), notice: '删除成功' }
    end
  end

  private
    def set_camp_document_summary
      @camp_document_summary = CampDocumentSummary.find(params[:id])
    end

    def camp_document_summary_params
      params.require(:camp_document_summary).permit!
    end
end
