class Api::V1::InstallFeedbacksController < Api::V1::BaseController

  def create
    @user = current_user
    apply_id = params[:apply_id]
    content = params[:content]
    images = params[:images]
    @apply = ProjectSeasonApply.find(params[:apply_id])
    if params[:bookshelf_id].present?
      bookshelf_id = params[:bookshelf_id]
      @bookshelf = ProjectSeasonApplyBookshelf.find(params[:bookshelf_id])
      @install = InstallFeedback.new(content: content, project_season_apply_id: apply_id, project_id: @bookshelf.apply.project.id, project_season_id: @bookshelf.apply.season.id, project_season_apply_bookshelf_id: bookshelf_id, user_id: @user.id, owner: @bookshelf)
      if @install.save
        @install.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        api_success(data: {result: true}, message: '您的反馈已提交～')
      else
        api_success(data: {result: false}, message: '反馈提交失败，请重试！')
      end
    else
      @install = InstallFeedback.new(content: content, project_season_apply_id: apply_id, project_id: @apply.project.id, project_season_id: @apply.season.id, user_id: @user.id, owner: @apply)
      if @install.save
        @install.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        api_success(data: {result: true}, message: '您的反馈已提交～')
      else
        api_success(data: {result: false}, message: '反馈提交失败，请重试！')
      end
    end
  end

end
