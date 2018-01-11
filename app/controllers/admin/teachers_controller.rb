class Admin::TeachersController < Admin::BaseController
  before_action :set_teacher, only: [:show, :destroy, :edit, :update, :destroy]

  def index
    @search = Teacher.sorted.ransack(params[:q])
    scope = @search.result
    @teachers = scope.page(params[:page])
  end

  def show
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params)
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to admin_teachers_path, notice: '教师创建成功。' }
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
        format.html { redirect_to referer_or(admin_teachers_url), notice: '教师信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_teachers_url), notice: '教师已删除。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit!
    end
end
