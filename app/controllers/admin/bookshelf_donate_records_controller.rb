class Admin::BookshelfDonateRecordsController < Admin::BaseController
  before_action :set_donate_record, only: [:show, :destroy]
  before_action :set_project
  before_action :set_project_apply
  before_action :set_bookshelf

  def index
    @donate_records = @bookshelf.donates
    set_search_end_of_day(:created_at_lteq)
    @search = @donate_records.ransack(params[:q])
    scope = @search.result
    @donate_records = scope.sorted.page(params[:page])
  end

  def show
  end

  def new
  end

  def create
    respond_to do |format|
      if DonateRecord.platform_donate_bookshelf(params, @bookshelf)
        format.html {redirect_to admin_read_project_bookshelf_donate_records_path(@apply, bookshelf_id: @bookshelf.id), notice: '新增成功。'}
      else
        flash[:notice] = '检查余额或表单'
        format.html {render :new}
      end
    end
  end

  def destroy
    @donate_record.destroy
    respond_to do |format|
      format.html {redirect_to admin_read_project_bookshelf_donate_records_path(@apply, bookshelf_id: @bookshelf.id), notice: '删除成功。'}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_donate_record
    @donate_record = DonateRecord.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def donate_record_params
    params.require(:donate_record).permit!
  end

  def set_project
    @project = Project.find(Project.read_project.id)
    auth_operate_project(@project)
  end

  def set_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:bookshelf_id])
  end

  def set_project_apply
    @apply = ProjectSeasonApply.find(params[:read_project_id])
  end
end
