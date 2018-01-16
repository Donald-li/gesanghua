class Admin::IncomeRecordsController < Admin::BaseController
  before_action :set_admin_income_record, only: [:show, :edit, :update, :destroy]

  # GET /admin/income_records
  # GET /admin/income_records.json
  def index

  end

  # GET /admin/income_records/1
  # GET /admin/income_records/1.json
  def show
  end

  # GET /admin/income_records/new
  def new
    @admin_income_record = Admin::IncomeRecord.new
  end

  # GET /admin/income_records/1/edit
  def edit
  end

  # POST /admin/income_records
  # POST /admin/income_records.json
  def create
    @admin_income_record = Admin::IncomeRecord.new(admin_income_record_params)

    respond_to do |format|
      if @admin_income_record.save
        format.html { redirect_to @admin_income_record, notice: 'Income record was successfully created.' }
        format.json { render :show, status: :created, location: @admin_income_record }
      else
        format.html { render :new }
        format.json { render json: @admin_income_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/income_records/1
  # PATCH/PUT /admin/income_records/1.json
  def update
    respond_to do |format|
      if @admin_income_record.update(admin_income_record_params)
        format.html { redirect_to @admin_income_record, notice: 'Income record was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_income_record }
      else
        format.html { render :edit }
        format.json { render json: @admin_income_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/income_records/1
  # DELETE /admin/income_records/1.json
  def destroy
    @admin_income_record.destroy
    respond_to do |format|
      format.html { redirect_to admin_income_records_url, notice: 'Income record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_income_record
      @admin_income_record = Admin::IncomeRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_income_record_params
      params.fetch(:admin_income_record, {})
    end
end
