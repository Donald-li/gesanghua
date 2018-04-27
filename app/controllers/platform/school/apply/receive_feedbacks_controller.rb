class Platform::School::Apply::ReceiveFeedbacksController < Platform::School::BaseController

  def new
    if params[:apply_id].present?
      apply = ProjectSeasonApply.find(params[:apply_id])
      @receive = ReceiveFeedback.new(owner: apply)
    elsif params[:bookshelf_id].present?
      bookshelf = ProjectSeasonApplyBookshelf.find(params[:bookshelf_id])
      @receive = ReceiveFeedback.new(owner: bookshelf)
    elsif params[:supplement_id].present?
      supplement = BookshelfSupplement.find(params[:supplement_id])
      @receive = ReceiveFeedback.new(owner: supplement)
    end
  end

  def create
    @receive = ReceiveFeedback.new(receive_feedback_params.merge(user_id: current_user.id, school_id: current_user.teacher.school.id))
    if @receive.owner_type == 'ProjectSeasonApply'
      apply = @receive.owner
      @receive.project_id = apply.project.id
    elsif @receive.owner_type == 'ProjectSeasonApplyBookshelf' || @receive.owner_type == 'BookshelfSupplement'
      b = @receive.owner
      @receive.project_id = b.apply.project.id
    end
    if @receive.save
      @receive.attach_images(params[:image_ids])
      @receive.owner.to_feedback!
      if @receive.owner_type == 'ProjectSeasonApply'
        apply = @receive.owner
        @receive.project_season_id = apply.season.id
        @receive.project_season_apply_id = apply.id
      elsif @receive.owner_type == 'ProjectSeasonApplyBookshelf'
        bookshelf = @receive.owner
        @receive.project_season_id = bookshelf.apply.season.id
        @receive.project_season_apply_id = bookshelf.apply.id
        @receive.project_season_apply_bookshelf_id = bookshelf.id
      elsif @receive.owner_type == 'BookshelfSupplement'
        supplement = @receive.owner
        @receive.project_season_id = supplement.apply.season.id
        @receive.project_season_apply_id = supplement.apply.id
        @receive.project_season_apply_bookshelf_id = supplement.bookshelf.id
      end
      @receive.save
      if @receive.owner_type == 'ProjectSeasonApply'
        if @receive.project = Project.read_project
          redirect_to platform_school_apply_reads_path
        elsif @receive.project.goods?
          redirect_to platform_school_apply_goods_projects_path(pid: @receive.project.id)
        end
      elsif @receive.owner_type == 'ProjectSeasonApplyBookshelf'
        redirect_to bookshelves_platform_school_apply_read_path(@receive.owner.apply)
      elsif @receive.owner_type == 'BookshelfSupplement'
        redirect_to supplements_platform_school_apply_read_path(@receive.owner.apply)
      end
    else
      render :new, notice: '反馈提交失败，请重试'
    end
  end

  private
  def receive_feedback_params
    params.require(:receive_feedback).permit!
  end

end
