class Admin::VolunteersController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_volunteer, only: [:show, :edit, :update, :destroy, :switch, :switch_job]

  def index
    respond_to do |format|
      @search = Volunteer.where(approve_state: [:pass, :reject]).sorted.ransack(params[:q])
      scope = @search.result.includes(:user)
      @volunteers = scope.page(params[:page])
      format.html do # HTML页面
        @volunteers = scope.page(params[:page])
      end
      format.xlsx {
        @volunteers = scope.all
        response.headers['Content-Disposition'] = 'attachment; filename="志愿者名单"' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
  end

  def new
    @volunteer = Volunteer.new
  end

  def edit
  end

  def create
    user = User.find(volunteer_params[:user_id])
    @volunteer = Volunteer.new(volunteer_params.merge(approve_state: 2, name: user.name, phone: user.phone, province: user.province, city: user.city, district: user.district))
    @volunteer.gen_volunteer_no
    respond_to do |format|
      if @volunteer.save
        @volunteer.set_user_volunteer
        format.html {redirect_to admin_volunteers_path, notice: '新增成功'}
      else
        format.html {render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @volunteer.update(volunteer_params)
        format.html {redirect_to admin_volunteers_path, notice: '修改成功'}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @volunteer.destroy
    respond_to do |format|
      format.html {redirect_to admin_volunteers_path, notice: '删除成功'}
    end
  end

  def switch
    @volunteer.enable? ? @volunteer.disable! : @volunteer.enable!
    redirect_to admin_volunteers_path, notice: @volunteer.enable? ? '已启用' : '已禁用'
  end

  def switch_job
    @volunteer.available? ? @volunteer.leave! : @volunteer.available!
    redirect_to admin_volunteers_path, notice: @volunteer.available? ? '已标记为可接受任务' : '已标记为请假'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def volunteer_params
    params.require(:volunteer).permit!
  end
end
