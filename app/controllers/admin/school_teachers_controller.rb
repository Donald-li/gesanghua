class Admin::SchoolTeachersController < Admin::BaseController

  before_action :set_teacher, only: [:show, :destroy, :edit, :update, :destroy]
  before_action :set_school, only: [:new, :index, :create, :edit, :update]

  def index
    @search = @school.teachers.teacher.sorted.ransack(params[:q])
    scope = @search.result
    @teachers = scope.page(params[:page])
  end

  def show
  end

  def new
    @teacher = @school.teachers.new
  end

  def create
    @teacher = @school.teachers.new(teacher_params)
    respond_to do |format|
      result, notice = @teacher.admin_create_teacher
      if result
        if teacher_projects_params.present?
          teacher_projects_params.each do |teacher_project|
            TeacherProject.create(teacher: @teacher, project_id: teacher_project)
          end
        end
        format.html { redirect_to referer_or(admin_school_school_teachers_path(@school)), notice: '教师创建成功。' }
      else
        flash[:notice] = notice
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      result, notice = @teacher.update_teacher(teacher_params, current_user)
      if result
        @teacher.teacher_projects.destroy_all
        if teacher_projects_params.present?
          teacher_projects_params.each do |teacher_project|
            TeacherProject.create(teacher: @teacher, project_id: teacher_project)
          end
        end
        format.html { redirect_to referer_or(admin_school_school_teachers_url), notice: '教师信息已修改。' }
      else
        flash[:notice] = notice
        format.html { render :edit }
      end
    end
  end

  def destroy
    @teacher.destroy_teacher(current_user)
    respond_to do |format|
      format.html { redirect_to referer_or(admin_school_school_teachers_url), notice: '教师已删除。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit!
    end

    def teacher_projects_params
      params[:teacher_projects]
    end
end
