class Platform::School::TeachersController < Platform::School::BaseController

  before_action :set_teacher, only: [:edit, :update, :destroy]
  before_action :set_per, only: :index

  def index
    @teachers = current_user.school.teachers.teacher.includes(:projects).sorted.decode_page(params)
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
      result, notice = @teacher.bind_user_by_phone(current_user)
      if result
        format.html {redirect_to platform_school_teachers_path, notice: '创建成功。'}
      else
        flash[:notice] = notice || @teacher.errors.full_messages.join(',')
        format.html { render :new }
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
        flash[:notice] = @teacher.errors.full_messages.join(',')
        format.html { render :edit }
      end
    end
  end

  def destroy
    @teacher.destroy_teacher(current_user)
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
