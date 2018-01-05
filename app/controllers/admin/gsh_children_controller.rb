class Admin::GshChildrenController < Admin::BaseController
  before_action :set_gsh_child, only: [:show, :edit, :update, :destroy, :gsh_child_apply_records]
  
  def index
    @search = GshChild.sorted.ransack(params[:q])
    if @search.user_id
      scope = @search.result.joins(:user)
      @gsh_children = scope.page(params[:page])
    else
      scope = @search.result
      @gsh_children = scope.page(params[:page])
    end
  end

  def show
  end

  def new
    @gsh_child = GshChild.new
  end

  def create
    @gsh_child = GshChild.new(gsh_child_params)
    respond_to do |format|
      if @gsh_child.save
        format.html { redirect_to admin_gsh_children_url, notice: '格桑花孩子已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @gsh_child.update(gsh_child_params)
        format.html { redirect_to admin_gsh_children_url, notice: '格桑花孩子资料已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @gsh_child.destroy
    respond_to do |format|
      format.html { redirect_to admin_gsh_children_url, notice: '格桑花孩子已删除。' }
    end
  end

  private
  def set_gsh_child
    @gsh_child = GshChild.find(params[:id])
  end

  def gsh_child_params
    params.require(:gsh_child).permit!
  end

end
