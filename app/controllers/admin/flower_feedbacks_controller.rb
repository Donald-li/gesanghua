class Admin::FlowerFeedbacksController < Admin::BaseController
  before_action :set_feedback, only: [:show, :destroy]
  # before_action :set_project, only: [:index]
  before_action :set_project_apply, only: [:index]

  def index
    @feedbacks = @apply.feedbacks
    @search = @feedbacks.ransack(params[:q])
    scope = @search.result
    @feedbacks = scope.sorted.page(params[:page])
  end

  def new
    @feedback = DonateRecord.new
  end

  def edit
  end

  def create
    @donate_record = DonateRecord.new(donate_record_params)

    respond_to do |format|
      if @donate_record.save
        format.html { redirect_to @donate_record, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
  end

  def destroy
    @donate_record.destroy
    respond_to do |format|
      format.html { redirect_to donate_records_url, notice: '删除成功。' }
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
      @project = Project.find(ProjectSeason.flower_project_id)
    end

    def set_project_apply
      @apply = ProjectSeasonApply.find(params[:flower_project_id])
    end
end
