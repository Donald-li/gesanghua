class Admin::PairStudentListsController < Admin::BaseController
  before_action :check_auth
  before_action :set_pair_student_list, only: [:show, :edit, :update, :destroy, :switch, :remarks, :turn_over, :share, :qrcode_download]

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

  def switch
    @pair_student_list.show? ? @pair_student_list.hidden! : @pair_student_list.show!
    redirect_to admin_pair_student_lists_path, notice:  @pair_student_list.show? ? '已开启筹款' : '已关闭筹款'
  end

  def remarks
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @search = @apply_child.remarks.sorted.ransack(params[:q])
    scope = @search.result
    @remarks = scope.page(params[:page])
  end

  def turn_over
    @pair_student_list.inside? ? @pair_student_list.outside! : @pair_student_list.inside!
    redirect_to admin_pair_student_lists_path, notice:  @pair_student_list.inside? ? '标记内部认捐成功' : '标记对外捐助成功'
  end

  def share
    @pair_student_list.generate_qrcode
  end

  def qrcode_download
    send_file(File.join(Rails.root, 'public', @pair_student_list.qrcode_url), filename: "#{@pair_student_list.gsh_child.gsh_no}-分享二维码")
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

    def check_auth
      auth_operate_project(Project.pair_project)
    end
end
