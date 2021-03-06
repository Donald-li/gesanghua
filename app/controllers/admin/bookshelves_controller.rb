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

  # 计提管理费
  def accrue
    @item = ProjectSeasonApplyBookshelf.find(params[:id])
    @project = Project.read_project
    @management_fee = ManagementFee.new
    render template: '/admin/management_fees/accrue'
  end

  def update
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @bookshelf.attach_image(params[:image_id])
    respond_to do |format|
      if @bookshelf.update(bookshelf_params)
        format.html { redirect_to referer_or(admin_read_project_bookshelves_path(@project)), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def switch
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @bookshelf.show? ? @bookshelf.hidden! : @bookshelf.show!
    redirect_to referer_or(admin_read_project_bookshelves_path(@project)), notice:  @bookshelf.show? ? '已显示' : '已隐藏'
  end

  def shipment
    store_referer
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @logistic = Logistic.new
  end

  def create_shipment
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @logistic = Logistic.new(logistic_params.merge(owner: @bookshelf))
    respond_to do |format|
      if @logistic.save
        @bookshelf.to_receive!
        format.html { redirect_to referer_or(admin_read_project_bookshelves_path(@project)), notice: '发货成功。' }
      else
        format.html { render :shipment }
      end
    end
  end

  def bookshelf_receive
    store_referer
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @receive = @bookshelf.receive_feedback
  end

  def bookshelf_install
    store_referer
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @install = @bookshelf.install_feedback
  end

  def feedback_switch
    store_referer
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @feedback = Feedback.find_by(id: params[:feedback_id])
    @feedback.show? ? @feedback.hidden! : @feedback.show!
    redirect_to referer_or(bookshelf_install_admin_read_project_bookshelf_path(@project, @bookshelf))
  end

  def feedback_edit
    store_referer
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @feedback = Feedback.find_by(id: params[:feedback_id])
  end

  def feedback_update
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @feedback = Feedback.find_by(id: params[:feedback_id])
    if @feedback.update(params.require(:feedback).permit!)
      @feedback.attach_images(params[:image_ids])
      redirect_to referer_or(bookshelf_install_admin_read_project_bookshelf_path(@project, @bookshelf))
    else
      flash.now[:alert] = '保存失败'
      render :feedback_edit
    end
  end

  private
  def set_project
    @project = ProjectSeasonApply.find(params[:read_project_id])

  end

  def bookshelf_params
    params.require(:project_season_apply_bookshelf).permit!
  end

  def logistic_params
    params.require(:logistic).permit!
  end
end
