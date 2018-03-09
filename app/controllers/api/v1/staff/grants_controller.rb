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
      # @feedback.attach_images(@image_ids)
      api_success(data: {result: true, grant_id: @grant.id}, message: '发放成功')
      return true
    else
      api_success(data: {result: false}, message: '发放成功，请重试！')
      return false
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
