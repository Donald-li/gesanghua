class Admin::ServiceHistoriesController < Admin::BaseController
  before_action :set_service_history, only: [:show, :edit, :update, :destroy]
  before_action :set_volunteer

  def index
    @search = @volunteer.task_volunteers.sorted.ransack(params[:q])
    scope = @search.result
    @service_histories = scope.page(params[:page])
  end

  def show
  end

  def new
    @service_history = Task.new
  end

  def edit
  end

  def create
    @service_history = Task.new(service_history_params)

    respond_to do |format|
      if @service_history.save
        format.html { redirect_to admin_volunteers_service_history_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @service_history.update(service_history_params)
        format.html { redirect_to admin_volunteers_service_history_path, notice: '' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @service_history.destroy
    respond_to do |format|
      format.html { redirect_to admin_volunteers_service_history_path, notice: 'Service history was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_history
      @service_history = Task.find(params[:id])
    end

    def set_volunteer
      @volunteer = Volunteer.find(params[:volunteer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_history_params
      params.require(:service_history).permit!
    end
end
