class Admin::SchoolTeachersController < Admin::BaseController
  before_action :set_teacher, only: [:show, :destroy, :edit, :update, :destroy]
  before_action :set_school, only: [:new, :index, :create, :edit, :update]

  def index
    @search = @school.teachers.sorted.ransack(params[:q])
    scope = @search.result
    @school_teachers = scope.page(params[:page])
  end

  def show
  end

  def new
    @school_teacher = @school.teachers.new
  end

  def create
    @school_teacher = @school.teachers.new(teacher_params)
    if @school_teacher.user.present?
      @user = @school_teacher.user
      @school_teacher.name = @user.name
      @school_teacher.phone = @user.phone
      @school_teacher.qq = @user.qq
      @school_teacher.openid = @user.openid
      @school_teacher.idcard = @user.idcard
    end
    respond_to do |format|
      if @school_teacher.save
        format.html { redirect_to admin_school_school_teachers_path, notice: '教师创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    if teacher_params[:user_id] !=nil && teacher_params[:user_id] != nil
      @user = User.find(:user_id)
    end
    respond_to do |format|
      if @school_teacher.update(teacher_params)
        @school_teacher.name = @user.name
        @school_teacher.phone = @user.phone
        @school_teacher.qq = @user.qq
        @school_teacher.openid = @user.openid
        @school_teacher.idcard = @user.idcard
        @school_teacher.save
        format.html { redirect_to referer_or(admin_school_school_teachers_url), notice: '教师信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school_teacher.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_school_school_teachers_url), notice: '教师已删除。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @school_teacher = Teacher.find(params[:id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:school_teacher).permit!
    end
end
