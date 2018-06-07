class Admin::SupplementsController < Admin::BaseController
  before_action :check_auth
  before_action :set_project

  def index
    @search = @project.supplements.pass.sorted.ransack(params[:q])
    scope = @search.result
    @supplements = scope.page(params[:page])
  end

  def show
    @supplement = BookshelfSupplement.find(params[:id])
    @note = @supplement.receive
    store_referer
  end

  def edit
    @supplement = BookshelfSupplement.find(params[:id])
  end

  def update
    @supplement = BookshelfSupplement.find(params[:id])
    # @supplement.attach_images(params[:image_ids])
    respond_to do |format|
      if @supplement.update(supplement_params)
        format.html { redirect_to referer_or(admin_read_project_supplements_path(@project)), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def switch
    @supplement = BookshelfSupplement.find(params[:id])
    @supplement.show? ? @supplement.hidden! : @supplement.show!
    redirect_to referer_or(admin_read_project_supplements_path(@project)), notice:  @supplement.show? ? '已显示' : '已隐藏'
  end

  def shipment
    @supplement = BookshelfSupplement.find(params[:id])
    @logistic = Logistic.new
    store_referer
  end

  def create_shipment
    @supplement = BookshelfSupplement.find(params[:id])
    @logistic = Logistic.new(logistic_params.merge(owner: @supplement))
    respond_to do |format|
      if @logistic.save
        @supplement.to_receive!
        format.html { redirect_to referer_or(admin_read_project_supplements_path(@project)), notice: '发货成功。' }
      else
        format.html { render :shipment }
      end
    end
  end

  def supplement_receive
    @supplement = BookshelfSupplement.find(params[:id])
    @receive = @supplement.receive_feedback
    store_referer
  end

  def supplement_install
    @supplement = BookshelfSupplement.find(params[:id])
    @install = @supplement.install_feedback
    store_referer
  end

  private
  def set_project
    @project = ProjectSeasonApply.find(params[:read_project_id])
  end

  def supplement_params
    params.require(:bookshelf_supplement).permit!
  end

  def logistic_params
    params.require(:logistic).permit!
  end

  def check_auth
    auth_operate_project(Project.read_project)
  end

end
