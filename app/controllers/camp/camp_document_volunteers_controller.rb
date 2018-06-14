class Camp::CampDocumentVolunteersController < Camp::CampDocumentBaseController
  before_action :set_camp_document_volunteer, only: [:show, :edit, :update, :destroy]

  def index
    @search = CampDocumentVolunteer.in_apply(@current_apply).sorted.ransack(params[:q])
    scope = @search.result
    @camp_document_volunteers = scope.page(params[:page])
  end

  def show
  end

  def new
    @camp_document_volunteer = CampDocumentVolunteer.new
  end

  def edit
  end

  def create
    if @camp_document_volunteer = CampDocumentVolunteer.in_apply(@current_apply).find_by(volunteer_id: camp_document_volunteer_params[:volunteer_id])
      flash[:alert] = '该志愿者已经添加，请直接修改信息'
      render :new
      return
    end

    @camp_document_volunteer = CampDocumentVolunteer.new(camp_document_volunteer_params.merge(user: current_user, apply: @current_apply, camp: @current_apply.camp))
    respond_to do |format|
      if @camp_document_volunteer.save
        format.html {redirect_to camp_camp_document_volunteers_url, notice: '新增成功'}
      else
        format.html {render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @camp_document_volunteer.update(camp_document_volunteer_params)
        format.html {redirect_to camp_camp_document_volunteers_url, notice: '修改成功'}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @camp_document_volunteer.destroy
    respond_to do |format|
      format.html {redirect_to camp_camp_document_volunteers_url, notice: '删除成功'}
    end
  end

  def excel_upload
  end

  def excel_import
    respond_to do |format|
      result = CampDocumentVolunteer.read_excel(params[:camp_volunteer_excel_id], @current_apply, current_user)
      if result[:status]
        format.html {redirect_to referer_or(camp_camp_document_volunteers_url), notice: '导入成功'}
      else
        flash.now[:alert] = result[:message]
        format.html {render :excel_upload}
      end
    end
  end


  private
  def set_camp_document_volunteer
    @camp_document_volunteer = CampDocumentVolunteer.find(params[:id])
  end

  def camp_document_volunteer_params
    params.require(:camp_document_volunteer).permit!
  end
end
