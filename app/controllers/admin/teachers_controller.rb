class Admin::TeachersController < Admin::BaseController

  before_action :set_teacher, only: [:show, :destroy, :edit, :update, :destroy]

  def index
    @search = Teacher.sorted.includes(:school, :teacher_projects).ransack(params[:q])
    scope = @search.result
    @teachers = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      result, notice = @teacher.update_teacher(teacher_params, current_user)
      if result
        format.html { redirect_to referer_or(admin_teachers_url), notice: notice }
      else
        flash[:notice] = notice || @teacher.errors.full_messages.join(',')
        format.html { render :edit }
      end
    end
  end

  def destroy
    result, notice = @teacher.destroy_teacher(current_user)
    respond_to do |format|
      if result
        format.html { redirect_to referer_or(admin_teachers_url), notice: '教师已删除。' }
      else
        format.html { redirect_to referer_or(admin_teachers_url), notice: '操作失败' }
      end

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
