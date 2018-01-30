class Admin::VolunteersController < Admin::BaseController
  before_action :set_volunteer, only: [:show, :edit, :update, :destroy, :switch, :switch_job]
  before_action :set_user, only: [:new, :create]

  def index
    @search = Volunteer.pass.sorted.ransack(params[:q])
    scope = @search.result.joins(:user)
    @volunteers = scope.page(params[:page])
  end

  def show
  end

  def new
    @volunteer = Volunteer.new
  end

  def edit
  end

  def create
    @volunteer = Volunteer.new(volunteer_params.merge(approve_state: 2, user_id: @user.id))
    @volunteer.gen_volunteer_no
    respond_to do |format|
      if @volunteer.save
        format.html { redirect_to admin_volunteers_path, notice: '新增成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @volunteer.update(volunteer_params)
        format.html { redirect_to admin_volunteers_path, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @volunteer.destroy
    respond_to do |format|
      format.html { redirect_to admin_volunteers_path, notice: '删除成功' }
    end
  end

  def switch
    @volunteer.enable? ? @volunteer.disable! : @volunteer.enable!
    redirect_to admin_volunteers_path, notice:  @volunteer.enable? ? '已启用' : '已禁用'
  end

  def switch_job
    @volunteer.available? ? @volunteer.leave! : @volunteer.available!
    redirect_to admin_volunteers_path, notice:  @volunteer.available? ? '已标记为可接受任务' : '已标记为请假'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer
      @volunteer = Volunteer.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def volunteer_params
      params.require(:volunteer).permit!
    end
end
