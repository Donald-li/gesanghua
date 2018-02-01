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
      if @bookshelf.update(bookshelf_params)
        format.html { redirect_to admin_read_project_bookshelves_path(@project), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def switch
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @bookshelf.show? ? @bookshelf.hidden! : @bookshelf.show!
    redirect_to admin_read_project_bookshelves_path(@project), notice:  @bookshelf.show? ? '对外展示' : '暂不展示'
  end

  private
  def set_project
    @project = ProjectSeasonApply.find(params[:read_project_id])
  end

  def bookshelf_params
    params.require(:project_season_apply_bookshelf).permit!
  end
end
