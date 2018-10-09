# 格桑花孩子的捐助记录
class Admin::ApplyRecordsController < Admin::BaseController

  before_action :set_apply_record, only: [:show]
  before_action :set_gsh_child

  def index
    @search = @gsh_child.project_season_apply_children.sorted.ransack(params[:q])
    scope = @search.result
    @apply_records = scope.page(params[:page])
  end

  def show
    @project = @apply_record.project
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apply_record
      @apply_record = ProjectSeasonApplyChild.find(params[:id])
    end

    def set_gsh_child
      @gsh_child = GshChild.find(params[:gsh_child_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def apply_record_params
      params.require(:apply_record).permit!
    end
end
