class Admin::TeachersController < Admin::BaseController
  before_action :set_teacher, only: [:show, :destroy, :edit, :update, :destroy]

  def index
    @search = Teacher.sorted.ransack(params[:q])
    scope = @search.result
    @teachers = scope.page(params[:page])
  end

  #def show
  #end

  #def new
  #  @teacher = Teacher.new
  #end

  def create
    @teacher = Teacher.new(teacher_params)
    if @teacher.user.present?
      @user = @teacher.user
      @teacher.name = @user.name
      @teacher.phone = @user.phone
      @teacher.qq = @user.qq
      @teacher.openid = @user.openid
      @teacher.idcard = @user.idcard
    end
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to admin_teachers_path, notice: '教师创建成功。' }
      else
        format.html { redirect_to new_admin_school_school_teacher_path(@teacher.school, @teacher), notice: '教师创建失败，请检查表单项填写。' }
      end
    end
  end

  def edit
  end

  def update
    if teacher_params[:user_id] !=nil && teacher_params[:user_id] != ""
      @user = User.find(teacher_params[:user_id])
    end
    respond_to do |format|
      if @teacher.update(teacher_params)
        @teacher.name = @user.name
        @teacher.phone = @user.phone
        @teacher.qq = @user.qq
        @teacher.openid = @user.openid
        @teacher.idcard = @user.idcard
        @teacher.save
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
