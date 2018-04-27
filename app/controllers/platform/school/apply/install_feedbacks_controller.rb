class Platform::School::Apply::InstallFeedbacksController < Platform::School::BaseController

  def new
    if params[:apply_id].present?
      apply = ProjectSeasonApply.find(params[:apply_id])
      @install = InstallFeedback.new(owner: apply)
    elsif params[:bookshelf_id].present?
      bookshelf = ProjectSeasonApplyBookshelf.find(params[:bookshelf_id])
      @install = InstallFeedback.new(owner: bookshelf)
    elsif params[:supplement_id].present?
      supplement = BookshelfSupplement.find(params[:supplement_id])
      @install = InstallFeedback.new(owner: supplement)
    end
  end

  def create
    @install = InstallFeedback.new(install_feedback_params.merge(user_id: current_user.id, school_id: current_user.teacher.school.id))
    if @install.owner_type == 'ProjectSeasonApply'
      apply = @install.owner
      @install.project_id = apply.project.id
    elsif @install.owner_type == 'ProjectSeasonApplyBookshelf' || @install.owner_type == 'BookshelfSupplement'
      b = @install.owner
      @install.project_id = b.apply.project.id
    end
    if @install.save
      @install.attach_images(params[:image_ids])
      @install.owner.feedbacked!
      if @install.owner_type == 'ProjectSeasonApply'
        apply = @install.owner
        @install.project_season_id = apply.season.id
        @install.project_season_apply_id = apply.id
      elsif @install.owner_type == 'ProjectSeasonApplyBookshelf'
        bookshelf = @install.owner
        @install.project_season_id = bookshelf.apply.season.id
        @install.project_season_apply_id = bookshelf.apply.id
        @install.project_season_apply_bookshelf_id = bookshelf.id
      elsif @install.owner_type == 'BookshelfSupplement'
        supplement = @install.owner
        @install.project_season_id = supplement.apply.season.id
        @install.project_season_apply_id = supplement.apply.id
        @install.project_season_apply_bookshelf_id = supplement.bookshelf.id
      end
      @install.save
      if @install.owner_type == 'ProjectSeasonApply'
        if @install.project == Project.read_project
          redirect_to platform_school_apply_reads_path
        elsif @install.project.goods?
          redirect_to platform_school_apply_goods_projects_path(pid: @install.project.id)
        end
      elsif @install.owner_type == 'ProjectSeasonApplyBookshelf'
        redirect_to bookshelves_platform_school_apply_read_path(@install.owner.apply)
      elsif @install.owner_type == 'BookshelfSupplement'
        redirect_to supplements_platform_school_apply_read_path(@install.owner.apply)
      end
    else
      render :new, notice: '反馈提交失败，请重试'
    end
  end

  private
  def install_feedback_params
    params.require(:install_feedback).permit!
  end

end
