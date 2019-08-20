class Admin::TaskVolunteersController < Admin::BaseController
  before_action :set_task_volunteer, only: [:show, :edit, :update, :destroy]
  before_action :set_volunteer

  def index
    @search = @volunteer.task_volunteers.done.sorted.ransack(params[:q])
    scope = @search.result
    @task_volunteers = scope.page(params[:page])
  end

  def show
  end

  def new
    @task_volunteer = TaskVolunteer.new(kind: 2)
  end

  def edit
  end

  def create
    if params[:kind] == 'reduce'
      task_volunteer_params[:duration] = 0 - task_volunteer_params[:duration].to_i
    end
    @task_volunteer = TaskVolunteer.new(task_volunteer_params.merge(volunteer: @volunteer, kind: 2, state: 'done', finish_time: Time.now, user_id: current_user.id))

    respond_to do |format|
      if @task_volunteer.save
        format.html { redirect_to referer_or(admin_volunteer_task_volunteers_path(@volunteer)), notice: '操作成功。' }
      else
        format.html { render :new }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_volunteer
      @task_volunteer = TaskVolunteer.find(params[:id])
    end

    def set_volunteer
      @volunteer = Volunteer.find(params[:volunteer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_volunteer_params
      params.require(:task_volunteer).permit!
    end
end
