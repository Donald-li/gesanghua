class Admin::SchoolAppliesController < Admin::BaseController
  before_action :set_school_apply, only: [:edit, :show, :update, :check]

  def index
    @search = School.can_check.sorted.ransack(params[:q])
    scope = @search.result
    @school_applies = scope.page(params[:page])
  end

  def edit
  end

  def show
  end

  def update
    respond_to do |format|
      if @school_apply.update(school_apply_params)
        @school_apply.attach_images(params[:image_ids])
        format.html { redirect_to admin_school_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school.destroy
    respond_to do |format|
      format.html { redirect_to admin_school_applies_path, notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      approve_state = school_apply_params[:approve_state] == 'pass' ? 'pass' : 'reject'
      @school_apply.approve_state = approve_state
      if @school_apply.save
        # if approve_state == 'pass'
        #   @school_apply.gen_school_user
        # end
        @school_apply.audits.create(state: approve_state, user_id: current_user.id, comment: school_apply_params[:approve_remark])
        format.html { redirect_to admin_school_applies_path, notice: '操作成功' }
      else
        format.html { render :show }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_apply
      @school_apply = School.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_apply_params
      params.require(:school).permit!
    end
end
