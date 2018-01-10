class Admin::TeachersController < Admin::BaseController
  before_action :set_teacher, only: [:show, :destroy, :edit, :update, :destroy]
  before_action :set_school, only: [:new, :index, :create, :edit, :update]

  def index
    @search = @school.teachers.sorted.ransack(params[:q])
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
      if @teacher.save
        format.html { redirect_to admin_school_teachers_path, notice: '教师创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to referer_or(admin_school_teachers_url), notice: '教师信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_school_teachers_url), notice: '教师已删除。' }
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
end
