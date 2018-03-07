class Api::V1::AppliesController < Api::V1::BaseController
  before_action :set_project
  before_action :set_apply, only: [:show]

  def index
    @book_applies = ProjectSeasonApply.where(project: Project.read_project).pass.show.sorted
    @book_applies = @book_applies.where(school_city: params[:city]) if params[:city].present?
    @book_applies = @book_applies.where(school_district: params[:district]) if params[:district].present?
    @book_applies = @book_applies.page(params[:page]).per(params[:per])
    api_success(data: {read_list: @book_applies.map{|item| item.summary_builder if item.present?}, pagination: json_pagination(@book_applies)})
  end

  def show
    api_error(message: '无效项目') && return unless @apply

    if @project.id == 2 # 悦读
      api_success(data: @apply.read_apply_detail_builder)
    end
  end

  private
  def set_project
    @project = Project.find_by(alias: params[:project_name]) || Project.pair_project
  end

  def set_apply
    @apply = ProjectSeasonApply.find_by(project: @project, id: params[:id])
  end

end
