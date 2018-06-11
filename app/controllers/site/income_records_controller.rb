class Site::IncomeRecordsController < Site::BaseController

  def index
    @search = IncomeRecord.can_count.ransack(params[:q])
    scope = @search.result
    @income_records = scope.includes(:fund, :income_source, :donor, :agent).sorted.page(params[:page])
  end

end
