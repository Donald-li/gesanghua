class Admin::ReadReportsController < Admin::BaseController
  before_action :check_auth
  before_action :set_report, only: [:edit, :update, :destroy, :switch]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = ProjectReport.where(project_id: Project.read_project.id).sorted.ransack(params[:q])
    scope = @search.result
    @reports = scope.page(params[:page])
  end

  def new
    @report = ProjectReport.new
  end

  def edit
  end

  def create
    @report = ProjectReport.new(report_params.merge(project_id: Project.read_project.id, user_id: current_user.id))
    @report.attach_images(params[:image_ids])
    respond_to do |format|
      if @report.save
        format.html { redirect_to referer_or(admin_read_reports_url), notice: '报告已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @report.attach_images(params[:image_ids])
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to referer_or(admin_read_reports_url), notice: '报告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_read_reports_url), notice: '报告已删除。' }
    end
  end

  def switch
    @report.show? ? @report.hidden! : @report.show!
    redirect_to referer_or(admin_read_reports_url), notice:  @report.show? ? '报告已展示' : '报告已隐藏'
  end

  private
    def set_report
      @report = ProjectReport.find(params[:id])
    end

    def report_params
      params.require(:project_report).permit!
    end

    def check_auth
      auth_operate_project(Project.pair_project)
    end

end
