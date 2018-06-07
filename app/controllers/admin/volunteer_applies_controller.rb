class Admin::VolunteerAppliesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_volunteer_apply, only: [:show, :edit, :update, :destroy]

  def index
    @search = Volunteer.submit.sorted.ransack(params[:q])
    scope = @search.result
    @applies = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      approve_state = volunteer_apply_params[:approve_state] == 'pass' ? 'pass' : 'reject'
      @apply.approve_state = approve_state
      if approve_state == 'pass'
        @apply.gen_volunteer_no
        @apply.enable!
        user = @apply.user
        user.roles = user.roles.push(:volunteer)
        user.save
      else
        @apply.disable!
      end
      if @apply.save
        @apply.audits.create(state: approve_state, user_id: current_user.id, comment: volunteer_apply_params[:approve_remark])

        # 审核通过发通知
        owner = @apply
        if approve_state == 'pass'
          title = "#志愿者申请# 审核已通过"
          content = "你的志愿者申请已经审核通过。 "
        else
          title = "#志愿者申请# 审核未通过"
          content = "你的志愿者申请审核未通过 未通过理由: #{volunteer_apply_params[:approve_remark]}"
        end
        notice = Notification.create(
          kind: approve_state == 'pass' ? 'approve_pass' : 'approve_reject',
          owner: owner,
          user_id: owner.user.id,
          title: title,
          content: content
        )

        format.html { redirect_to referer_or(admin_volunteer_applies_path), notice: '操作成功' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_apply
      @apply = Volunteer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def volunteer_apply_params
      params.require(:volunteer).permit!
    end
end
