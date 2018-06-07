class Site::ExpenditureRecordsController < Site::BaseController

  def index
    @search = ExpenditureRecord.ransack(params[:q])
    scope = @search.result
    @expenditure_records = scope.includes(:expenditure_ledger, :secure_operator).sorted.page(params[:page])
  end

  def show
    @expenditure_record = ExpenditureRecord.find(params[:id])
  end

end
