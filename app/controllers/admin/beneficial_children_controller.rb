class Admin::BeneficialChildrenController < Admin::BaseController
  before_action :set_child, only: [:show, :edit, :update, :destroy]

  def new
    @child = BeneficialChild.new(project_season_apply_id: params[:apply_id])
  end

  def edit
  end

  def create
    @child = BeneficialChild.new(child_params)
    respond_to do |format|
      if @child.save
        format.html { redirect_to referer_or(request.referer), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @child.update(child_params)
        format.html { redirect_to referer_or(request.referer), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @child.destroy
    respond_to do |format|
      format.html { redirect_to request.referer, notice: '删除成功。' }
    end
  end

  def excel_upload
    @project_apply = ProjectSeasonApply.find(params[:apply_id])
  end

  def excel_import
    @project_apply = ProjectSeasonApply.find(params[:apply_id])
    respond_to do |format|
      if BeneficialChild.read_excel(params[:children_excel_id], @project_apply.id, params[:project_season_apply_bookshelf_id])
        if @project_apply.project_id == ProjectSeason.radio_project_id
          format.html {redirect_to edit_admin_radio_apply_path(@project_apply, anchor: 'tab_1'), notice: '操作成功'}
        elsif @project_apply.project_id == ProjectSeason.movie_project_id
          format.html {redirect_to edit_admin_movie_apply_path(@project_apply, anchor: 'tab_1'), notice: '操作成功'}
        elsif @project_apply.project_id == ProjectSeason.book_project_id && params[:project_season_apply_bookshelf_id].present?
          format.html {redirect_to students_admin_read_apply_path(@project_apply, q: {project_season_apply_bookshelf_id_eq: params[:project_season_apply_bookshelf_id]}), notice: '操作成功'}
        elsif @project_apply.present?
          format.html {redirect_to edit_admin_radio_apply_path(@project_apply, anchor: 'tab_1'), notice: '操作成功'}
        end
        # format.html {redirect_to referer_or(request.referer), notice: '操作成功'}
      else
        format.html {render :excel_upload}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = BeneficialChild.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_params
      params.require(:beneficial_child).permit!
    end
end
