class Api::V1::ReadsController < Api::V1::BaseController
  before_action :set_project, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyBookshelf.address_group)
  end

  def applies_list
    @book_applies = ProjectSeasonApply.where(project: Project.read_project).pass.show.sorted
    @book_applies = @book_applies.where(school_id: School.where(city: params[:city]).pluck(:id)) if params[:city].present?
    @book_applies = @book_applies.where(school_id: School.where(district: params[:district]).pluck(:id)) if params[:district].present?
    @book_applies = @book_applies.page(params[:page]).per(params[:per])
    api_success(data: {read_list: @book_applies.collect{|item| item.summary_builder}, pagination: json_pagination(@book_applies)})
  end

  private
  def set_project
    @project = Project.read_project
  end
end
