class Admin::ReadProjectsController < Admin::BaseController
  before_action :check_auth
  before_action :set_project, only: [:edit, :update, :switch, :supply_edit, :finish_project]

  def index
    @search = ProjectSeasonApply.where(project_id: [2, Project.book_supply_project.id]).raise_project.order(execute_state: :asc).sorted.ransack(params[:q])
    scope = @search.result.joins(:school)
    @projects = scope.page(params[:page])
  end

  def edit
  end

  def supply_edit
    store_referer
  end

  def update
    @project.attach_cover_image(params[:cover_image_id])
    respond_to do |format|
      if @project.update(project_params)
        @project.raise_project!
        if @project.whole?
          @project.target_amount = @project.bookshelves.pass.sum(:target_amount).to_f
          @project.save
        else
          @project.target_amount = @project.supplements.pass.sum(:target_amount).to_f
          @project.save
        end
        format.html { redirect_to referer_or(admin_read_projects_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def switch
    @project.show? ? @project.hidden! : @project.show!
    redirect_to referer_or(admin_read_projects_url), notice: @project.show? ? '项目已启用' : '项目已暂停'
  end

  def finish_project
    @project.read_done! && @project.done!
    redirect_to referer_or(admin_read_projects_path), notice: '操作成功。'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = ProjectSeasonApply.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project_season_apply).permit!
  end

  def check_auth
    auth_operate_project(Project.read_project)
  end

end
