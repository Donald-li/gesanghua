class Admin::PairStudentListsController < Admin::BaseController
  before_action :set_pair_student_list, only: [:show, :edit, :update, :destroy]

  def index
    @search = ProjectSeasonApplyChild.pass.sorted.ransack(params[:q])
    scope = @search.result
    @pair_student_lists = scope.page(params[:page])
  end

  def show
  end

  def new
    @pair_student_list = ProjectSeasonApplyChild.new
  end

  def edit
  end

  def create
    @pair_student_list = ProjectSeasonApplyChild.new(pair_student_list_params)

    respond_to do |format|
      if @pair_student_list.save
        format.html { redirect_to admin_pair_student_lists_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @pair_student_list.update(pair_student_list_params)
        format.html { redirect_to admin_pair_student_lists_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @pair_student_list.destroy
    respond_to do |format|
      format.html { redirect_to admin_pair_student_lists_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pair_student_list
      @pair_student_list = ProjectSeasonApplyChild.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pair_student_list_params
      params.require(:pair_season_apply_child).permit!
    end
end
