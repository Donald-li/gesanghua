class Admin::PairReportsController < Admin::BaseController
  before_action :set_report, only: [:edit, :update, :destroy, :switch]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = ProjectReport.where(project_id: 1).sorted.ransack(params[:q])
    scope = @search.result
    @reports = scope.page(params[:page])
  end

  def new
    @report = ProjectReport.new
  end

  def edit
  end

  def create
    @report = ProjectReport.new(report_params.merge(project_id: 1, user_id: current_user.id))
    @report.attach_images(params[:image_ids])
    respond_to do |format|
      if @report.save
        format.html { redirect_to referer_or(admin_pair_reports_url), report: '项目报告已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @report.attach_images(params[:image_ids])
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to referer_or(admin_pair_reports_url), report: '项目报告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_pair_reports_url), report: '项目报告已删除。' }
    end
  end

  def switch
    @report.show? ? @report.hidden! : @report.show!
    redirect_to admin_pair_reports_url, notice:  @report.show? ? '项目报告已展示' : '项目报告已隐藏'
  end

  private
    def set_report
      @report = ProjectReport.find(params[:id])
    end

    def report_params
      params.require(:project_report).permit!
    end
end