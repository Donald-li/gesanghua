class Admin::MajorsController < Admin::BaseController
  before_action :set_major, only: [:edit, :update, :destroy]

  def index
    @search = Major.sorted.ransack(params[:q])
    scope = @search.result
    @majors = scope.page(params[:page])
  end

  def new
    @major = Major.new
  end

  def edit
  end

  def create
    @major = Major.new(major_params)

    respond_to do |format|
      if @major.save
        format.html { redirect_to admin_majors_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @major.update(major_params)
        format.html { redirect_to admin_majors_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @major.destroy
    respond_to do |format|
      format.html { redirect_to admin_majors_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_major
      @major = Major.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def major_params
      params.require(:major).permit!
    end
end
