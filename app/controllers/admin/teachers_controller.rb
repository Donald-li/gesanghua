class Admin::TeachersController < Admin::BaseController
  before_action :set_teacher, only: [:show, :destroy, :edit, :update, :destroy]

  def index
    @search = Teacher.sorted.ransack(params[:q])
    scope = @search.result
    @teachers = scope.page(params[:page])
  end

  def edit
  end

  def update
    @u = @teacher.user if @teacher.user.present?
    if @u.present?
      @u.remove_role(:teacher)
      @u.save
    end
    @user = User.find(teacher_params[:user_id]) if teacher_params[:user_id].present?
    @school = School.find(teacher_params[:school_id]) if teacher_params[:school_id].present?
    if teacher_params[:kind] == 'headmaster'
      if @school.present?
        if @user.present?
          @school.change_school_user(@user)
        else
          @school.change_school_user(nil)
        end
      end
    else
      if @user.present?
        if !@user.has_role?(:teacher)
          @user.add_role(:teacher)
          @user.save
        end
      end
    end
    if !@user.present?
      teacher_params[:user_id] = nil
    end
    respond_to do |format|
      if @teacher.update(teacher_params)
        if @user.present?
          @teacher.name = @user.name
          @teacher.phone = @user.phone
          @teacher.qq = @user.qq
          @teacher.openid = @user.openid
          @teacher.id_card = @user.id_card
          @teacher.save
        end
        format.html { redirect_to referer_or(admin_teachers_url), notice: '教师信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @teacher.destroy
    if @teacher.user.present?
      if @teacher.user.has_role?(:teacher)
        @teacher.user.roles = @teacher.user.roles-[:teacher]
        @teacher.user.save
      end
    end
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
