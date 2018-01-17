class Admin::ExpenditureUploadsController < Admin::BaseController

  def new
  end

  def create
    return_value = ExpenditureUploadUtil.update_expenditure_upload_result(params[:file])
    @count = return_value[0]
    @hint = return_value[1]
    flash[:notice] = "共更新了#{@count.to_i}条信息。"
    redirect_to admin_expenditure_records_path
  end
end
