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
    @donate_record = DonateRecord.new
    @income_record = @donate_record.build_income_record
    @require = true
  end

  def create
    respond_to do |format|
      if donate_record_params[:donate_way] == 'offline'
        amount = donate_record_params[:offline_amount]
        @user = User.find(donate_record_params[:user_id])
        @donate_record = DonateRecord.new(donate_record_params.merge(fund: @apply.project.fund, pay_state: 'paid', amount: amount, project: @apply.project, donor: @user.name, remitter_id: @user.id, remitter_name: @user.name, season: @apply.season, apply: @apply, kind: 'custom'))
      else
        @match_fund = Fund.find(donate_record_params[:match_fund_id])
        amount = donate_record_params[:match_amount]
        @match_fund.amount -= amount.to_f
        @donate_record = DonateRecord.new(donate_record_params.merge(fund: @apply.project.fund, pay_state: 'paid', amount: amount, project: @apply.project, season: @apply.season, apply: @apply, kind: 'custom'))
      end
      @income_record = IncomeRecord.new(donate_record: @donate_record, user: @donate_record.user, fund: @donate_record.fund, amount: @donate_record.amount, remitter_id: @donate_record.remitter_id, remitter_name: @donate_record.remitter_name, donor: @donate_record.donor, promoter_id: @donate_record.promoter_id, income_time: Time.now)
      @income_record.income_source_id = donate_record_params[:income_record_attributes][:income_source_id] if donate_record_params[:income_record_attributes].present?
      if @donate_record.save && @income_record.save
        @match_fund.save if @match_fund.present?
        format.html {redirect_to admin_radio_project_radio_donate_records_path(@apply), notice: '新增成功。'}
      else
        format.html {render :new}
      end
    end
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
