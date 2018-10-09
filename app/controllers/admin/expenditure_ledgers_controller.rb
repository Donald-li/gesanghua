class Admin::ExpenditureLedgersController < Admin::BaseController

  before_action :set_ledger, only: [:edit, :update, :destroy, :move]

  def index
    @ledgers = ExpenditureLedger.sorted
  end

  def new
    @ledger = ExpenditureLedger.new
  end

  def create
    @ledger = ExpenditureLedger.new(ledger_params)

    respond_to do |format|
      if @ledger.save
        format.html { redirect_to referer_or(admin_expenditure_ledgers_path), notice: '添加成功' }
      else
        format.html { render :new }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @ledger.update(ledger_params)
        format.html { redirect_to referer_or(admin_expenditure_ledgers_path), notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @ledger.delete
    respond_to do |format|
      format.html { redirect_to referer_or(admin_expenditure_ledgers_path), notice: '删除成功' }
    end
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @ledger.send("move_#{move_target}")
    redirect_to request.referer
  end

  private

  def set_ledger
    @ledger = ExpenditureLedger.find(params[:id])
  end

  def ledger_params
    params.require(:expenditure_ledger).permit!
  end
end
