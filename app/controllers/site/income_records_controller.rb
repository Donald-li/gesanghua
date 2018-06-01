class Site::IncomeRecordsController < Site::BaseController

  def index
    @search = IncomeRecord.ransack(params[:q])
    scope = @search.result
    @income_records = scope.sorted.page(params[:page])
  end

end
