class Admin::SchoolAppliesController < Admin::BaseController

  before_action :set_school_apply, only: [:edit, :show, :update, :check, :destroy]

  def index
    @search = School.can_check.sorted.ransack(params[:q])
    scope = @search.result
    @school_applies = scope.page(params[:page])
  end

  def edit
  end

  def show
    store_referer
  end

  def update
    respond_to do |format|
      if @school_apply.update(school_apply_params)
        @school_apply.attach_images(params[:image_ids])
        format.html { redirect_to referer_or(admin_school_applies_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school_apply.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_school_applies_path), notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      approve_state = school_apply_params[:approve_state] == 'pass' ? 'pass' : 'reject'
      @school_apply.approve_state = approve_state
      if @school_apply.save
        if approve_state == 'pass'
          @school_apply.change_school_user(@school_apply.creater)
        end
        # if approve_state == 'pass' && User.find_by(phone: @school_apply.contact_phone).present?
        #   user = User.find_by(phone: @school_apply.contact_phone)
        #   @school_apply.change_school_user(user)
        # end
        @school_apply.audits.create(state: approve_state, user_id: current_user.id, comment: school_apply_params[:approve_remark])

        # 审核通过发通知
        owner = @school_apply
        if approve_state == 'pass'
          title = "#学校申请# 审核已通过"
          content = "你申请的学校 #{@school_apply.name} 已经审核通过。 "
        else
          title = "#学校申请# 审核未通过"
          content = "你申请的学校 #{@school_apply.name} 审核未通过 未通过理由: #{school_apply_params[:approve_remark]}"
        end
        notice = Notification.create(
          kind: approve_state == 'pass' ? 'approve_pass' : 'approve_reject',
          owner: owner,
          user_id: owner.creater.id,
          title: title,
          content: content,
          url: "#{Settings.m_root_url}/gesanghua+"
        )

        format.html { redirect_to referer_or(admin_school_applies_path), notice: '操作成功' }
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
