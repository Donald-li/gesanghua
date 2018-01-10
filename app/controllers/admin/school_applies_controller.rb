class Admin::SchoolAppliesController < Admin::BaseController
  before_action :set_school_apply, only: [:edit, :update]

  def index
    @search = School.can_check.sorted.ransack(params[:q])
    scope = @search.result
    @school_applies = scope.page(params[:page])
  end

  def new
    @school_apply = School.new
  end

  def edit
  end

  def create
    @school_apply = School.new(school_apply_params)

    respond_to do |format|
      if @school_apply.save
        @school_apply.attach_images(params[:image_ids])
        format.html { redirect_to admin_school_applies_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @school_apply.update(school_apply_params)
        @school_apply.attach_images(params[:image_ids])
        format.html { redirect_to admin_school_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school.destroy
    respond_to do |format|
      format.html { redirect_to admin_school_applies_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_apply
      @school_apply = School.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_apply_params
      params.require(:school).permit!
    end
end
