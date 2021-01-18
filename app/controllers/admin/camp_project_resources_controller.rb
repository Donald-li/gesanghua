class Admin::CampProjectResourcesController < Admin::BaseController
  before_action :set_camp_project_resource, only: [:show, :edit, :update, :destroy]

  def index
    @search = CampProjectResource.sorted.ransack(params[:q])
    scope = @search.result.includes(:camp)
    @camp_project_resources = scope.page(params[:page])
  end

  def show
  end

  def new
    @camp_project_resource = CampProjectResource.new
  end

  def edit
  end

  def create
    @camp_project_resource = CampProjectResource.new(camp_project_resource_params.merge(user: current_user))
    respond_to do |format|
      if @camp_project_resource.save
        format.html {redirect_to referer_or(admin_camp_project_resources_url), notice: '新增成功'}
      else
        format.html {render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @camp_project_resource.update(camp_project_resource_params)
        format.html {redirect_to referer_or(admin_camp_project_resources_url), notice: '修改成功'}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @camp_project_resource.destroy
    respond_to do |format|
      format.html {redirect_to referer_or(admin_camp_project_resources_url), notice: '删除成功'}
    end
  end

  private
  def set_camp_project_resource
    @camp_project_resource = CampProjectResource.find(params[:id])
  end

  def camp_project_resource_params
    params.require(:camp_project_resource).permit!
  end

end
