class Admin::CampDocumentFinancesController < Admin::CampDocumentBaseController
  before_action :set_camp_document_finance, only: [:show, :edit, :update, :destroy]

  def index
    @search = CampDocumentFinance.in_apply(@current_apply).sorted.ransack(params[:q])
    scope = @search.result
    @camp_document_finances = scope.page(params[:page])
  end

  def show
  end

  def new
    @camp_document_finance = CampDocumentFinance.new
  end

  def edit
  end

  def create
    @camp_document_finance = CampDocumentFinance.new(camp_document_finance_params.merge(user: current_user, apply: @current_apply))
    respond_to do |format|
      if @camp_document_finance.save
        format.html { redirect_to admin_camp_document_finances_url, notice: '新增成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @camp_document_finance.update(camp_document_finance_params)
        format.html { redirect_to admin_camp_document_finances_url, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @camp_document_finance.destroy
    respond_to do |format|
      format.html { redirect_to admin_camp_document_finances_url, notice: '删除成功' }
    end
  end

  private
    def set_camp_document_finance
      @camp_document_finance = CampDocumentFinance.find(params[:id])
    end

    def camp_document_finance_params
      params.require(:camp_document_finance).permit!
    end
end
