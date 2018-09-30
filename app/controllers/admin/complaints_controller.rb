class Admin::ComplaintsController < Admin::BaseController

  before_action :set_complaint, only: [:show, :edit, :update, :destroy]

  def index
    @search = Complaint.sorted.ransack(params[:q])
    scope = @search.result
    @complaints = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      if @complaint.update(complaint_params)
        notice = Notification.create(
            kind: 'handle_complaint',
            owner: @complaint,
            user_id: @complaint.user.id,
            title: '举报已处理',
            content: "#{current_user.name}已处理并备注：#{@complaint.remark}",
            url: "#{Settings.m_root_url}/account"
        )
        format.html { redirect_to referer_or(admin_complaints_path), notice: '举报已处理' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_complaint
      @complaint = Complaint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def complaint_params
      params.require(:complaint).permit!
    end
end
