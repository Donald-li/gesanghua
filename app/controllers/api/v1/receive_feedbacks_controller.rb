class Api::V1::ReceiveFeedbacksController < Api::V1::BaseController

  def create
    @user = current_user
    apply_id = params[:apply_id]
    content = params[:content]
    images = params[:images]
    @apply = ProjectSeasonApply.find(params[:apply_id])
    if params[:bookshelf_supplement_id].present?
      bookshelf_supplement_id = params[:bookshelf_supplement_id]
      @bookshelf_supplement = BookshelfSupplement.find(bookshelf_supplement_id)
      @receive = ReceiveFeedback.new(content: content, project_season_apply_id: apply_id, project_id: @bookshelf_supplement.apply.project.id, project_season_id: @bookshelf_supplement.apply.season.id, project_season_apply_bookshelf_id: @bookshelf_supplement.bookshelf.id, user_id: @user.id, owner: @bookshelf_supplement)
      if @receive.save
        @receive.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        @bookshelf_supplement.update(state: 4)
        api_success(data: {result: true}, message: '您的反馈已提交～')
      else
        api_success(data: {result: false}, message: '反馈提交失败，请重试！')
      end

      # 给捐款人发通知
      donor_ids = []
      @bookshelf_supplement.donates.each do |d|
        unless d.donor_id.in? donor_ids
          notice2 = Notification.create(
            owner: @bookshelf,
            user_id: d.donor_id,
            title: "#收货通知# 图书角已经收货",
            content: "你捐助的图书角补书已经收货。"
          )
          donor_ids << d.donor_id
        end
      end
    elsif params[:bookshelf_id].present?
      bookshelf_id = params[:bookshelf_id]
      @bookshelf = ProjectSeasonApplyBookshelf.find(bookshelf_id)
      @receive = ReceiveFeedback.new(content: content, project_season_apply_id: apply_id, project_id: @bookshelf.apply.project.id, project_season_id: @bookshelf.apply.season.id, project_season_apply_bookshelf_id: bookshelf_id, user_id: @user.id, owner: @bookshelf)
      if @receive.save
        @receive.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        @bookshelf.update(state: 4)
        api_success(data: {result: true}, message: '您的反馈已提交～')
      else
        api_success(data: {result: false}, message: '反馈提交失败，请重试！')
      end

      # 给捐助人发送收货反馈通知
      donor_ids = []
      @bookshelf.donates.each do |d|
        unless d.donor_id.in? donor_ids
          notice2 = Notification.create(
            owner: @bookshelf,
            user_id: d.donor_id,
            title: "#收货通知# 图书角已经收货",
            content: "你捐助的 #{@bookshelf.name} 图书角已经收货。"
          )
          donor_ids << d.donor_id
        end
      end
    else
      @receive = ReceiveFeedback.new(content: content, project_season_apply_id: apply_id, project_id: @apply.project.id, project_season_id: @apply.season.id, user_id: @user.id, owner: @apply)
      if @receive.save
        @receive.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        @apply.update(execute_state: 4)
        api_success(data: {result: true}, message: '您的反馈已提交～')
      else
        api_success(data: {result: false}, message: '反馈提交失败，请重试！')
      end
    end
  end

end
