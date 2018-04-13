class Platform::School::Apply::GoodsProjectsController < Platform::School::BaseController
  before_action :set_goods_project
  before_action :check_manage_limit
  
  def index
    scope = @current_project.applies.where(school_id: current_user.school)
    @applies = scope.sorted.page(params[:page]).per(7)
  end

  def show
    @apply = @current_project.applies.where(school_id: current_user.school).find(params[:id])
  end

  def new
    @apply = @current_project.applies.new
  end

  def create
    @apply = @current_project.applies.new(apply_params)
    @apply.school = current_user.school

    if @apply.save
      @apply.attach_images(params[:image_ids])
      redirect_to platform_school_apply_goods_projects_path(pid: @current_project)
    else
      render :new
    end
  end

  def edit
    @apply = @current_project.applies.where(school_id: current_user.school).find(params[:id])
  end

  def update
    @apply = @current_project.applies.where(school_id: current_user.school).find(params[:id])
    @apply.attributes = apply_params

    if @apply.save
      @apply.attach_images(params[:image_ids])
      redirect_to platform_school_apply_goods_projects_path(pid: @current_project)
    else
      render :edit
    end
  end

  private
  def check_manage_limit
    redirect_to root_path unless current_teacher.manage_projects.where(id: @current_project).exists?
  end

  def apply_params
    keys = @current_project.form.map{|i| i['key']} # 动态字段
    params.require(:project_season_apply).permit(:describe, :project_season_id, :student_number, :contact_name, :contact_phone, :address, :province, :city, :district, form: keys)
  end

  def set_goods_project
    @current_project ||= Project.goods.visible.find(params[:pid])
  end
end
