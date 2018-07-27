class Api::V1::Staff::GrantsController < Api::V1::BaseController

  before_action :set_batch
  before_action :set_grant, only: [:show, :update]

  def index
    search = @batch.grants.search(params[:q])
    grants = search.result.sorted.page(params[:page])
    api_success(data: {grants: grants.map { |r| r.summary_builder }, pagination: json_pagination(grants)})
  end

  def update
    @image_ids = params[:feedback][:images].pluck(:id)
    if @grant.update(
        grant_person: params[:feedback][:grant_person],
        granted_at: params[:feedback][:granted_at],
        grant_remark: params[:feedback][:grant_remark],
        state: 2
      )
      # @feedback = @grant.build_feedback(
      #   project_id: Project.pair_project.id,
      #   user_id: current_user.id,
      #   gsh_child_grant_id: @grant.id,
      #   content: params[:feedback][:grant_remark]
      # )
      # @feedback.save
      @grant.attach_images(@image_ids)

      # 给捐助人发送收货反馈通知
      notice = Notification.create(
        kind: 'feedback_grant',
        owner: @grant,
        user_id: @grant.user_id,
        title: "#发放通知# 你的捐款发放啦",
        content: "你捐助的 #{@grant.apply_child.name} 助学款已经发放。发放时间: #{ l(@grant.granted_at) } 发放人: #{ params[:feedback][:grant_person] }",
        url: "#{Settings.m_root_url}/pair/#{@grant.apply_child.try(:id)}"
      )

      # @feedback.attach_images(@image_ids)
      api_success(data: {result: true, grant_id: @grant.id}, message: '发放成功')
    else
      api_success(data: {result: false}, message: '发放成功，请重试！')
    end
  end

  def show

  end

  private
  def set_grant
    @grant = GshChildGrant.find(params[:id])
  end

  def set_batch
    @batch = GrantBatch.find(params[:grant_batch_id])
  end

  def grant_params
    params.permit(:grant_person, :grant_remark, :granted_at)
  end

end
