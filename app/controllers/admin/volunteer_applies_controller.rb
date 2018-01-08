class Admin::VolunteerAppliesController < Admin::BaseController
  before_action :set_volunteer_apply, only: [:show, :edit, :update, :destroy]

  def index
    @search = Volunteer.submit.sorted.ransack(params[:q])
    scope = @search.result
    @applies = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      @apply.approve_state = volunteer_apply_params[:approve_state] == 'pass' ? 2 : 3
      if @apply.save
        format.html { redirect_to admin_volunteer_applies_path, notice: '操作成功' }
      else
        format.html { render :edit }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_apply
      @apply = Volunteer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def volunteer_apply_params
      params.require(:volunteer).permit!
    end
end
