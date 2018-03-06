class Admin::CampDocumentVolunteersController < Admin::CampDocumentBaseController
  before_action :set_camp_document_volunteer, only: [:show, :edit, :update, :destroy]

    def index
      @search = CampDocumentVolunteer.in_season(@current_camp).sorted.ransack(params[:q])
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
      if @camp_document_volunteer = CampDocumentVolunteer.in_season(@current_camp).find_by(volunteer_id: camp_document_volunteer_params[:volunteer_id])
        flash[:alert] = '该志愿者已经添加，请直接修改信息'
        render :new
        return
      end

      @camp_document_volunteer = CampDocumentVolunteer.new(camp_document_volunteer_params.merge(user: current_user, project_season: @current_camp))
      respond_to do |format|
        if @camp_document_volunteer.save
          format.html { redirect_to admin_camp_document_volunteers_url, notice: '新增成功' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @camp_document_volunteer.update(camp_document_volunteer_params)
          format.html { redirect_to admin_camp_document_volunteers_url, notice: '修改成功' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @camp_document_volunteer.destroy
      respond_to do |format|
        format.html { redirect_to admin_camp_document_volunteers_url, notice: '删除成功' }
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
