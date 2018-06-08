class Site::ExpenditureRecordsController < Site::BaseController

  def index
    @search = ExpenditureRecord.can_count.ransack(params[:q])
    scope = @search.result
    @expenditure_records = scope.sorted.page(params[:page])
  end

  def show
    @expenditure_record = ExpenditureRecord.find(params[:id])
  end

end
