class Admin::ServiceHistoriesController < Admin::BaseController
  before_action :set_service_history, only: [:show]
  before_action :set_volunteer

  def index
    set_search_end_of_day(:finish_time_lteq)
    @search = @volunteer.task_volunteers.pass.normal.sorted.ransack(params[:q])
    scope = @search.result
    @service_histories = scope.page(params[:page])
  end

  def show
    @task = @service_history.task
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_history
      @service_history = TaskVolunteer.find(params[:id])
    end

    def set_volunteer
      @volunteer = Volunteer.find(params[:volunteer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_history_params
      params.require(:service_history).permit!
    end
end
