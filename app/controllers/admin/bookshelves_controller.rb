class Admin::BookshelvesController < Admin::BaseController
  before_action :set_project

  def index
    @search = @project.bookshelves.sorted.ransack(params[:q])
    scope = @search.result
    @bookshelves = scope.page(params[:page])
  end

  def edit
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
  end

  def update
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    # @bookshelf.attach_images(params[:image_ids])
    respond_to do |format|
      if @apply_child.update(bookshelf_params)
        format.html { redirect_to admin_read_projects_path(@project), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  private
  def set_project
    @project = ProjectSeasonApply.find(params[:read_project_id])
  end

  def bookshelf_params
    params.require(:project_season_apply_bookshelf).permit!
  end
end
