class Admin::BookshelvesController < Admin::BaseController
  before_action :set_project

  def index
    @search = @project.bookshelves.pass.sorted.ransack(params[:q])
    scope = @search.result
    @bookshelves = scope.page(params[:page])
  end

  def show
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @note = @bookshelf.receive
  end

  def edit
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
  end

  def update
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @bookshelf.attach_image(params[:image_id])
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
    redirect_to admin_read_project_bookshelves_path(@project), notice:  @bookshelf.show? ? '已显示' : '已隐藏'
  end

  def shipment
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @bookshelf.non_reception!
    respond_to do |format|
      format.html { redirect_to admin_read_project_bookshelves_path(@project), notice: '发货成功。' }
    end
  end

  def bookshelf_receive
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @receive = @bookshelf.receive
  end

  private
  def set_project
    @project = ProjectSeasonApply.find(params[:read_project_id])
  end

  def bookshelf_params
    params.require(:project_season_apply_bookshelf).permit!
  end
end
