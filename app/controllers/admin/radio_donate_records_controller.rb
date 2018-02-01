class Admin::RadioDonateRecordsController < Admin::BaseController
  before_action :set_donate_record, only: [:show, :destroy]
  before_action :set_project
  before_action :set_project_apply

  def index
    @donate_records = @project.donate_records.paid
    set_search_end_of_day(:created_at_lteq)
    @search = @donate_records.ransack(params[:q])
    scope = @search.result
    @donate_records = scope.sorted.page(params[:page])
  end

  def show
  end

  def new
  end

  def create
    render :new
    # if params[:donate_way] == 'offline'
    #   amount = params[:offline_amount]
    # elsif params[:donate_way] == 'match'
    #   amount = params[:match_amount]
    # end
    # respond_to do |format|
    #   if @apply.match_donate(params, amount, nil)
    #     @apply.present_amount += amount.to_f
    #     @apply.execute_state = 'to_execute' if @apply.present_amount == @apply.target_amount
    #     @apply.save
    #     format.html {redirect_to admin_radio_project_radio_donate_records_path(@apply), notice: '新增成功。'}
    #   else
    #     @max = @apply.target_amount - @apply.present_amount
    #     flash[:notice] = '检查余额或表单'
    #     format.html {render :new}
    #   end
    # end
  end

  def destroy
    @donate_record.destroy
    respond_to do |format|
      format.html {redirect_to admin_radio_project_radio_donate_records_path(@apply), notice: '删除成功。'}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_donate_record
    @donate_record = DonateRecord.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def donate_record_params
    params.require(:donate_record).permit!
  end

  def set_project
    @project = Project.find(ProjectSeason.radio_project_id)
  end

  def set_project_apply
    @apply = ProjectSeasonApply.find(params[:radio_project_id])
  end
end
