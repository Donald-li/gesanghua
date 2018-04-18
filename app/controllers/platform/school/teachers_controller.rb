class Platform::School::TeachersController < Platform::School::BaseController

  before_action :set_teacher, only: [:edit, :update, :destroy]
  before_action :set_per, only: :index

  def index
    @teachers = Teacher.includes(:projects).sorted.decode_page(params)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params.merge(school: current_user.school))
    #@teacher.attach_avatar(params[:avatar_id])
    respond_to do |format|
      if @teacher.save
        format.html {redirect_to platform_school_teachers_path, notice: '创建成功。'}
      else
        format.html {render :new, notice: @teacher.errors.full_messages}
      end
    end
  end

  def edit

  end

  def update
    @teacher.project_ids = params[:teacher][:project_ids]
    respond_to do |format|
      if @teacher.update(teacher_params)
        #@teacher.attach_avatar(params[:avatar_id])
        format.html {redirect_to platform_school_teachers_path, notice: '教师已修改。'}
      else
        format.html {render :edit, notice: @teacher.errors.full_messages}
      end
    end
  end

  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html {redirect_to platform_school_teachers_path, notice: '删除成功。'}
    end
  end

  private

  def set_teacher
    @teacher = Teacher.find_by_id(params[:id])
  end

  def teacher_params
    params.require(:teacher).permit!
  end

  def set_per
    params[:per] = 10
  end

end
